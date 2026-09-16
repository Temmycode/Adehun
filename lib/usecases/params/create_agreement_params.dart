class CreateAgreementParams {
  final String otherParticipantEmailOrPhone;
  final String role;
  final String title;
  final String description;

  /// Naira with at most two decimals, as a string (e.g. "1500.50"). Sent
  /// verbatim so kobo precision survives; the API rejects more than 2dp.
  final String amount;
  final List<CreateConditionParams> conditions;

  const CreateAgreementParams({
    required this.otherParticipantEmailOrPhone,
    required this.role,
    required this.title,
    required this.description,
    required this.amount,
    required this.conditions,
  });

  /// Normalises user input ("1,500.5") into the wire format ("1500.50").
  static String formatAmount(double value) => value.toStringAsFixed(2);
}

class CreateConditionParams {
  final String title;
  final String description;
  final String requiredFromEmail;

  const CreateConditionParams({
    required this.title,
    required this.description,
    required this.requiredFromEmail,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'required_from_email': requiredFromEmail,
  };
}
