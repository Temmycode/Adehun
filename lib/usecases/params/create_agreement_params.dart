class CreateAgreementParams {
  final String otherParticipantEmailOrPhone;
  final String role;
  final String title;
  final String description;
  final int amount;
  final List<CreateConditionParams> conditions;

  const CreateAgreementParams({
    required this.otherParticipantEmailOrPhone,
    required this.role,
    required this.title,
    required this.description,
    required this.amount,
    required this.conditions,
  });
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
