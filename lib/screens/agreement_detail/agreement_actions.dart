import '../../utils/agreement_status.dart';

/// Things a user can do to an agreement from its detail screen.
enum AgreementAction { agree, fund, raiseDispute, cancel }

/// The one primary action for this user and status, an optional secondary,
/// and what goes in the overflow menu.
class AgreementActions {
  final AgreementAction? primary;
  final AgreementAction? secondary;
  final List<AgreementAction> overflow;

  const AgreementActions({
    this.primary,
    this.secondary,
    this.overflow = const [],
  });

  static const none = AgreementActions();

  bool get hasBar => primary != null || secondary != null;
}

/// Pure so it can be unit tested without widgets or providers.
///
/// - Pending: agree if there are conditions and the user has not yet agreed;
///   cancelling is always available.
/// - Active: the depositor funds escrow if it is still empty; anyone can
///   raise a dispute while none is live; an unfunded agreement can still be
///   cancelled.
/// - Completed, disputed, cancelled, refunded: nothing to do.
AgreementActions resolveAgreementActions({
  required String? status,
  required bool isDepositor,
  required bool isFunded,
  required bool currentUserAccepted,
  required bool hasConditions,
  required bool hasLiveDispute,
}) {
  switch (AgreementStatusHelper.normalize(status)) {
    case AgreementStatusHelper.draft:
    case AgreementStatusHelper.pending:
      final canAgree = hasConditions && !currentUserAccepted;
      return AgreementActions(
        primary: canAgree ? AgreementAction.agree : null,
        secondary: AgreementAction.cancel,
        overflow: const [AgreementAction.cancel],
      );
    case AgreementStatusHelper.active:
      final canFund = !isFunded && isDepositor && !hasLiveDispute;
      return AgreementActions(
        primary: canFund ? AgreementAction.fund : null,
        secondary: hasLiveDispute ? null : AgreementAction.raiseDispute,
        overflow: [
          if (!hasLiveDispute) AgreementAction.raiseDispute,
          if (!isFunded) AgreementAction.cancel,
        ],
      );
    default:
      return AgreementActions.none;
  }
}

String agreementActionLabel(AgreementAction action, {required bool isDepositor}) {
  return switch (action) {
    AgreementAction.agree =>
      isDepositor ? 'Agree & fund escrow' : 'Agree & activate',
    AgreementAction.fund => 'Fund escrow',
    AgreementAction.raiseDispute => 'Raise a dispute',
    AgreementAction.cancel => 'Cancel agreement',
  };
}
