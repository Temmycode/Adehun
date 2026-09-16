import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/data/services/user_api_service.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:adehun_mvp/domain/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserRepoImpl implements UserRepository {
  final UserApiService _api;

  const UserRepoImpl(UserApiService api) : _api = api;

  @override
  Future<DataState<UserData>> getCurrentUser() async {
    try {
      final response = await _api.getCurrentUser();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const GetProfileError());
    } catch (err) {
      if (kDebugMode) log('getCurrentUser failed: ${err.runtimeType}');
      return DataFailed(const GetProfileError());
    }
  }

  @override
  Future<DataState<UserData>> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    try {
      final response = await _api.updateUser(userId, {
        'name': ?name,
        'phone_number': ?phoneNumber,
        'profile_picture_url': ?profilePictureUrl,
      });
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const UpdateProfileError());
    } catch (err) {
      if (kDebugMode) log('updateProfile failed: ${err.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<DataState<UploadSignatureResponse>> getProfileUploadSignature() async {
    try {
      final response = await _api.getProfileUploadSignature();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(const UploadSignatureError());
    } catch (err) {
      if (kDebugMode) log('profile signature failed: ${err.runtimeType}');
      return DataFailed(const UploadSignatureError());
    }
  }
}
