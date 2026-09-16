import 'package:adehun_mvp/controllers/agreement_controller.dart';
import 'package:adehun_mvp/controllers/condition_controller.dart';
import 'package:adehun_mvp/controllers/invitation_providers.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/utils/format_currency.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/avatar_initials.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/money_text.dart';
import '../widgets/status_pill.dart';

/// Shows a pending invitation for [agreementId] and lets the user accept or
/// decline it. The invitation is resolved from the server, never from a
/// payload smuggled through the URL.
class AgreementInvitationScreen extends ConsumerStatefulWidget {
  final String agreementId;

  const AgreementInvitationScreen({super.key, required this.agreementId});

  @override
  ConsumerState<AgreementInvitationScreen> createState() =>
      _AgreementInvitationScreenState();
}

class _AgreementInvitationScreenState
    extends ConsumerState<AgreementInvitationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(conditionControllerProvider.notifier)
          .getAgreementConditions(widget.agreementId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final invitations = ref.watch(invitedAgreementsProvider);
    final invitation = invitations.value
        ?.where((inv) => inv.agreement.id == widget.agreementId)
        .firstOrNull;

    final agState = ref.watch(agreementControllerProvider);
    final isAccepting = agState.value?.isAccepting ?? false;
    final isDeclining = agState.value?.isDeclining ?? false;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Invitation'),
      bottomNavigationBar: invitation == null
          ? null
          : BottomActionBar(
              secondary: SecondaryButton(
                label: 'Decline',
                tone: ButtonTone.danger,
                loading: isDeclining,
                onPressed: isDeclining || isAccepting
                    ? null
                    : () => _decline(invitation),
              ),
              primary: PrimaryButton(
                label: invitation.role == 'depositor' ? 'Accept & fund' : 'Accept',
                icon: Iconsax.tick_circle,
                loading: isAccepting,
                onPressed: isAccepting || isDeclining
                    ? null
                    : () => _acceptAndFund(invitation),
              ),
            ),
      body: invitations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ListStatePlaceholder.error(
          heading: "Couldn't load the invitation",
          detail: 'Check your connection and try again.',
          onRetry: () => ref.invalidate(invitedAgreementsProvider),
        ),
        data: (_) => invitation == null
            ? ListStatePlaceholder(
                icon: Iconsax.document_text_copy,
                title: 'Invitation not found',
                message:
                    'It may have been accepted, declined, or has expired. Open the agreement from your list instead.',
                actionLabel: 'Go to agreements',
                primaryAction: true,
                onAction: () => context.go('/agreements'),
              )
            : _InvitationBody(invitation: invitation),
      ),
    );
  }

  Future<void> _decline(InvitationResponse invitation) async {
    final id = invitation.agreement.id;
    if (id == null) return;
    await ref.read(agreementControllerProvider.notifier).declineAgreement(id);
  }

  /// Accepts, then moves the escrow funds in (a no-op for a beneficiary).
  Future<void> _acceptAndFund(InvitationResponse invitation) async {
    final id = invitation.agreement.id;
    if (id == null) return;
    final notifier = ref.read(agreementControllerProvider.notifier);

    final accepted = await notifier.acceptAgreement(id);
    if (!mounted) return;
    if (!accepted) {
      showAppToast(
        context,
        "Couldn't accept the agreement. Please try again.",
        kind: ToastKind.error,
      );
      return;
    }
    ref.invalidate(invitedAgreementsProvider);

    await notifier.fundAgreement(id);
    if (!mounted) return;

    final error = ref.read(agreementControllerProvider).value?.fundError;
    if (error == null) {
      context.go('/agreement/$id');
      return;
    }
    showAppToast(context, error, kind: ToastKind.error);
    notifier.clearFundError();
  }
}

class _InvitationBody extends ConsumerWidget {
  final InvitationResponse invitation;

  const _InvitationBody({required this.invitation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final agreement = invitation.agreement;
    final invitedBy = invitation.invitedByUser;
    final inviterName = invitedBy.name?.trim().isNotEmpty == true
        ? invitedBy.name!.trim()
        : 'Someone';
    final firstName = inviterName.split(RegExp(r'\s+')).first;
    final amount = double.tryParse(agreement.amount ?? '') ?? 0;
    final conditions =
        ref.watch(conditionControllerProvider).conditionsFor(agreement.id ?? '');
    final isDepositor = invitation.role == 'depositor';
    final description = agreement.description?.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.xxxl,
      ),
      children: [
        AppCard(
          color: colors.primarySurface,
          bordered: false,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              AvatarInitials(
                name: inviterName,
                imageUrl: invitedBy.profilePictureUrl,
                size: 64,
                showBorder: true,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '$inviterName invited you',
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                isDepositor
                    ? "You'd be paying $firstName through escrow."
                    : "$firstName would be paying you through escrow.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ).entrance(context, 0),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agreement.title ?? 'Untitled agreement',
                style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
              ),
              if (description != null && description.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escrow amount',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        MoneyText(
                          amount,
                          style: AppTextStyles.amountMedium,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  StatusPill(
                    label: isDepositor ? 'You pay' : 'You get paid',
                    foreground: AppColors.primary,
                    background: colors.primarySurface,
                    icon: isDepositor ? Iconsax.money_send : Iconsax.money_recive,
                  ),
                ],
              ),
            ],
          ),
        ).entrance(context, 1),
        if (conditions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Conditions (${conditions.length})',
            style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isDepositor
                ? 'The money is released only after you approve each of these.'
                : 'You get paid once each of these is delivered and approved.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                for (var i = 0; i < conditions.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colors.primarySurface,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            conditions[i].title ?? 'Untitled condition',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ).entrance(context, 2),
        ],
        const SizedBox(height: AppSpacing.xxl),
        InfoBanner(
          tone: isDepositor ? BannerTone.warning : BannerTone.info,
          message: isDepositor
              ? 'Accepting moves ${formatMoney(amount)} from your wallet into escrow. If your wallet is short, we top it up first.'
              : 'Accepting activates the agreement. $firstName funds the escrow. Nothing is charged to you.',
        ).entrance(context, 3),
      ],
    );
  }
}
