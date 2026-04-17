enum NotificationType {
  invitationReceived,
  agreementAccepted,
  agreementDeclined,
  conditionAdded,
  conditionUpdated,
  agreementCompleted,
  general;

  static NotificationType fromRaw(String raw) => switch (raw) {
    'invitation_received' => NotificationType.invitationReceived,
    'agreement_accepted' => NotificationType.agreementAccepted,
    'agreement_declined' => NotificationType.agreementDeclined,
    'condition_added' => NotificationType.conditionAdded,
    'condition_updated' => NotificationType.conditionUpdated,
    'agreement_completed' => NotificationType.agreementCompleted,
    _ => NotificationType.general,
  };
}
