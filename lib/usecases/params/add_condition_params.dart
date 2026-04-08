class AddConditionParams {
  final String agreementId;
  final String title;
  final String description;
  final String requiredFromEmail;

  const AddConditionParams({
    required this.agreementId,
    required this.title,
    required this.description,
    required this.requiredFromEmail,
  });
}
