/// Mirrors the API's `NotificationType` enum.
///
/// [general] is the catch-all for anything the server adds that this build
/// doesn't know about yet, so a new type degrades to a plain tile instead of
/// throwing.
enum NotificationType {
  invitationReceived,
  agreementAccepted,
  agreementDeclined,
  agreementCancelled,
  agreementCompleted,
  conditionAdded,
  conditionUpdated,
  escrowFunded,
  escrowReleased,
  escrowRefunded,
  walletCredited,
  withdrawalCompleted,
  withdrawalFailed,
  disputeRaised,
  disputeEvidenceAdded,
  disputeUnderReview,
  disputeResolved,
  general;

  static NotificationType fromRaw(String raw) => switch (raw) {
    'invitation_received' => NotificationType.invitationReceived,
    'agreement_accepted' => NotificationType.agreementAccepted,
    'agreement_declined' => NotificationType.agreementDeclined,
    'agreement_cancelled' => NotificationType.agreementCancelled,
    'agreement_completed' => NotificationType.agreementCompleted,
    'condition_added' => NotificationType.conditionAdded,
    'condition_updated' => NotificationType.conditionUpdated,
    'escrow_funded' => NotificationType.escrowFunded,
    'escrow_released' => NotificationType.escrowReleased,
    'escrow_refunded' => NotificationType.escrowRefunded,
    'wallet_credited' => NotificationType.walletCredited,
    'withdrawal_completed' => NotificationType.withdrawalCompleted,
    'withdrawal_failed' => NotificationType.withdrawalFailed,
    'dispute_raised' => NotificationType.disputeRaised,
    'dispute_evidence_added' => NotificationType.disputeEvidenceAdded,
    'dispute_under_review' => NotificationType.disputeUnderReview,
    'dispute_resolved' => NotificationType.disputeResolved,
    _ => NotificationType.general,
  };

  /// Anything about money moving — these deep-link to the wallet rather than
  /// to an agreement.
  bool get isWalletEvent =>
      this == walletCredited ||
      this == withdrawalCompleted ||
      this == withdrawalFailed;

  /// Dispute activity. These route to the agreement, whose detail screen shows
  /// the dispute — NOT to `/dispute/:id`, which is the raise-a-dispute form.
  bool get isDisputeEvent =>
      this == disputeRaised ||
      this == disputeEvidenceAdded ||
      this == disputeUnderReview ||
      this == disputeResolved;

  /// Escrow movements, all of which belong to an agreement.
  bool get isEscrowEvent =>
      this == escrowFunded || this == escrowReleased || this == escrowRefunded;
}
