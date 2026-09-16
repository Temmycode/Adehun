import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:adehun_mvp/domain/models/attention_item.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:adehun_mvp/utils/agreement_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'attention_controller.g.dart';

/// Derives the "Needs your attention" feed from data other providers already
/// hold. It makes no requests of its own, so it is only as fresh as the
/// agreement list, the pending invitations and whatever conditions have been
/// loaded for individual agreements.
///
/// Order is by urgency: invitations, agreements waiting for the user to agree,
/// escrow the user still has to fund, submitted conditions the user has to
/// review, then open disputes.
@riverpod
List<AttentionItem> attentionItems(Ref ref) {
  final me = ref.watch(authControllerProvider).userData;
  final invites = ref.watch(invitedAgreementsProvider).value ?? const [];
  final agreements =
      ref.watch(agreementControllerProvider).value?.agreements ?? const [];
  final conditions = ref.watch(conditionControllerProvider);

  final items = <AttentionItem>[];
  final seenAgreements = <String>{};

  for (final invite in invites) {
    if (invite.status.toLowerCase() != 'pending') continue;
    final id = invite.agreement.id;
    if (id == null) continue;
    seenAgreements.add(id);
    final from = invite.invitedByUser.name?.trim();
    items.add(
      AttentionItem(
        kind: AttentionKind.invitation,
        title: 'Accept or decline',
        subtitle: from == null || from.isEmpty
            ? (invite.agreement.title ?? 'New agreement')
            : '$from invited you: ${invite.agreement.title ?? 'New agreement'}',
        route: '/agreement-invitation/$id',
        agreementId: id,
      ),
    );
  }

  for (final agreement in agreements) {
    final id = agreement.id;
    if (id == null || seenAgreements.contains(id)) continue;
    final title = agreement.title ?? 'Untitled agreement';
    final status = AgreementStatusHelper.normalize(agreement.status);
    final iAmDepositor = _isMe(agreement.depositor, me?.email, me?.id);
    final iAmParty =
        iAmDepositor || _isMe(agreement.beneficiary, me?.email, me?.id);

    if (status == AgreementStatusHelper.pending &&
        iAmParty &&
        !agreement.currentUserAccepted) {
      items.add(
        AttentionItem(
          kind: AttentionKind.agree,
          title: 'Review and agree',
          subtitle: title,
          route: '/agreement/$id',
          agreementId: id,
        ),
      );
      continue;
    }

    if (status == AgreementStatusHelper.active &&
        iAmDepositor &&
        !agreement.isFunded) {
      items.add(
        AttentionItem(
          kind: AttentionKind.fund,
          title: 'Fund escrow',
          subtitle: title,
          route: '/agreement/$id',
          agreementId: id,
        ),
      );
      continue;
    }

    if (status == AgreementStatusHelper.disputed) {
      items.add(
        AttentionItem(
          kind: AttentionKind.dispute,
          title: 'Dispute open',
          subtitle: title,
          route: '/agreement/$id',
          agreementId: id,
        ),
      );
      continue;
    }

    if (status == AgreementStatusHelper.active && iAmDepositor) {
      for (final condition in conditions.conditionsFor(id)) {
        if ((condition.status ?? '').toLowerCase() != 'submitted') continue;
        items.add(
          AttentionItem(
            kind: AttentionKind.review,
            title: 'Review "${condition.title ?? 'condition'}"',
            subtitle: title,
            route: '/condition/${condition.id}?agreementId=$id',
            agreementId: id,
          ),
        );
      }
    }
  }

  const order = {
    AttentionKind.invitation: 0,
    AttentionKind.agree: 1,
    AttentionKind.fund: 2,
    AttentionKind.review: 3,
    AttentionKind.dispute: 4,
  };
  items.sort((a, b) => order[a.kind]!.compareTo(order[b.kind]!));
  return items;
}

bool _isMe(Participant? p, String? email, String? id) {
  if (p == null) return false;
  if (id != null && p.id != null && p.id == id) return true;
  if (email != null && p.email != null) {
    return p.email!.toLowerCase() == email.toLowerCase();
  }
  return false;
}
