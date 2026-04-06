class RegisterUserParams {
  final String userId;
  final String phoneNumber;
  final String fullName;

  const RegisterUserParams({
    required this.userId,
    required this.phoneNumber,
    required this.fullName,
  });
}
