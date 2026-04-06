import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/data/services/auth_api_service.dart';
import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthApiService _authApiService;
  const AuthRepoImpl(AuthApiService apiService) : _authApiService = apiService;

  @override
  Future<DataState<LoginResponse>> googleSignIn() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleIdToken = googleUser.authentication.idToken;

      if (googleIdToken == null) {
        return DataFailed(LoginFailedError());
      }

      // Sign into Firebase Auth to get a Firebase ID token
      final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        return DataFailed(LoginFailedError());
      }

      final apiResponse = await _authApiService.googleSignIn({
        "id_token": firebaseIdToken,
      });

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(LoginFailedError());
    } on GoogleSignInException {
      return DataFailed(LoginFailedError());
    } catch (err, stk) {
      print("fail");
      print('$err, $stk');
      rethrow;
    }
  }

  @override
  Future<DataState<LoginResponse>> registerFromInvite(
    String idToken,
    String invitationToken,
  ) async {
    try {
      final apiResponse = await _authApiService.registerFromInvite({
        "id_token": idToken,
        "invitation_token": invitationToken,
      });

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(InvitationRegistrationError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<UserData>> registerUser({
    required String userId,
    required String phoneNumber,
    required String fullName,
  }) async {
    try {
      final apiResponse = await _authApiService.registerUser({
        "user_id": userId,
        "phone_number": phoneNumber,
        "name": fullName,
      });

      if (apiResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(RegistrationError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
