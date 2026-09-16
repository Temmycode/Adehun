import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/data/services/auth_api_service.dart';
import 'package:adehun_mvp/domain/auth_repository.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthApiService _authApiService;
  const AuthRepoImpl(AuthApiService apiService) : _authApiService = apiService;

  /// Runs the Google -> Firebase handshake and returns a Firebase ID token.
  Future<String?> _firebaseIdToken() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleIdToken = googleUser.authentication.idToken;
    if (googleIdToken == null) return null;

    final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user?.getIdToken();
  }

  @override
  Future<DataState<LoginResponse>> googleSignIn() async {
    try {
      final firebaseIdToken = await _firebaseIdToken();
      if (firebaseIdToken == null) return DataFailed(LoginFailedError());

      final apiResponse = await _authApiService.googleSignIn({
        "id_token": firebaseIdToken,
      });

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }
      return DataFailed(LoginFailedError());
    } on GoogleSignInException {
      return DataFailed(LoginFailedError());
    } catch (err) {
      // Never log the exception body: a DioException stringifies the request,
      // which for /auth/login includes the Firebase ID token.
      if (kDebugMode) log('googleSignIn failed: ${err.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<DataState<LoginResponse>> googleSignInWithInvite(
    String invitationToken,
  ) async {
    try {
      final firebaseIdToken = await _firebaseIdToken();
      if (firebaseIdToken == null) return DataFailed(LoginFailedError());
      return registerFromInvite(firebaseIdToken, invitationToken);
    } on GoogleSignInException {
      return DataFailed(LoginFailedError());
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
    } catch (err) {
      if (kDebugMode) log('registerFromInvite failed: ${err.runtimeType}');
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

      final status = apiResponse.response.statusCode;
      if (status == HttpStatus.ok || status == HttpStatus.created) {
        return DataSuccess(apiResponse.data);
      }
      return DataFailed(RegistrationError());
    } catch (err) {
      if (kDebugMode) log('registerUser failed: ${err.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _authApiService.logout({"refresh_token": refreshToken});
    } catch (err) {
      if (kDebugMode) log('logout failed: ${err.runtimeType}');
    }
  }
}
