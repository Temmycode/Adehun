class CreateAgreementParams {
  final String participantEmail;
  final String role;
  final String title;
  final String description;
  final int amount;

  const CreateAgreementParams({
    required this.participantEmail,
    required this.role,
    required this.title,
    required this.description,
    required this.amount,
  });
}
