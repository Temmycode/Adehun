import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponse>> googleSignIn();

  /// Google sign-in that also validates an invitation token, for users who
  /// arrived through an emailed invite link.
  Future<DataState<LoginResponse>> googleSignInWithInvite(String invitationToken);

  Future<DataState<UserData>> registerUser({
    required String userId,
    required String phoneNumber,
    required String fullName,
  });

  Future<DataState<LoginResponse>> registerFromInvite(
    String idToken,
    String invitationToken,
  );

  /// Best-effort server-side revocation of the refresh token.
  Future<void> logout(String refreshToken);
}
