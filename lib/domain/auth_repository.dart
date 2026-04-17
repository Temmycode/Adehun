import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponse>> googleSignIn();

  Future<DataState<UserData>> registerUser({
    required String userId,
    required String phoneNumber,
    required String fullName,
  });

  Future<DataState<LoginResponse>> registerFromInvite(
    String idToken,
    String invitationToken,
  );
}
