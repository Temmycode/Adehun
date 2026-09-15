import 'dart:developer';

import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/core/network/api_error_handler.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/states/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  ProfileState build() => const ProfileState();

  /// Pull the latest profile so a stale cached copy never shows on screen.
  Future<void> refreshFromServer() async {
    final result = await ref.read(userRepositoryProvider).getCurrentUser();
    if (!ref.mounted) return;
    if (result is DataSuccess && result.data != null) {
      await ref.read(authControllerProvider.notifier).setUser(result.data);
    }
  }

  Future<bool> save({required String name, required String phoneNumber}) async {
    if (state.isBusy) return false;
    final userId = ref.read(authControllerProvider).userData?.id;
    if (userId == null) {
      state = state.copyWith(errorMessage: () => 'Please sign in again.');
      return false;
    }
    state = state.copyWith(isSaving: true, errorMessage: () => null);
    try {
      final result = await ref
          .read(userRepositoryProvider)
          .updateProfile(userId: userId, name: name, phoneNumber: phoneNumber);
      if (!ref.mounted) return false;
      if (result is DataSuccess && result.data != null) {
        await ref.read(authControllerProvider.notifier).setUser(result.data);
        state = state.copyWith(isSaving: false);
        return true;
      }
      state = state.copyWith(
        isSaving: false,
        errorMessage: () => result.exception?.toString(),
      );
      return false;
    } on DioException catch (err) {
      final apiError = err.error;
      state = state.copyWith(
        isSaving: false,
        errorMessage: () => apiError is ApiError
            ? handleApiError(apiError)
            : "Couldn't save your profile.",
      );
      return false;
    } catch (err) {
      log('profile save failed: $err');
      state = state.copyWith(
        isSaving: false,
        errorMessage: () => "Couldn't save your profile.",
      );
      return false;
    }
  }

  /// Picks an image, uploads it to Cloudinary with a server-issued signature,
  /// then stores the resulting URL on the profile.
  Future<bool> changeAvatar() async {
    if (state.isBusy) return false;
    final userId = ref.read(authControllerProvider).userData?.id;
    if (userId == null) return false;

    final picked = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (picked == null || picked.files.isEmpty) return false;

    state = state.copyWith(isUploadingAvatar: true, errorMessage: () => null);
    try {
      final signature = await ref
          .read(userRepositoryProvider)
          .getProfileUploadSignature();
      if (signature is! DataSuccess || signature.data == null) {
        throw StateError('no signature');
      }
      final uploaded = await ref
          .read(cloudinaryUploadServiceProvider)
          .uploadFiles(signature.data!, [
            FileResponse.fromFile(picked.files.single),
          ]);
      final url = uploaded.first.url;
      if (url.isEmpty) throw StateError('no url');

      final result = await ref
          .read(userRepositoryProvider)
          .updateProfile(userId: userId, profilePictureUrl: url);
      if (!ref.mounted) return false;
      if (result is DataSuccess && result.data != null) {
        await ref.read(authControllerProvider.notifier).setUser(result.data);
        state = state.copyWith(isUploadingAvatar: false);
        return true;
      }
      state = state.copyWith(
        isUploadingAvatar: false,
        errorMessage: () => result.exception?.toString(),
      );
      return false;
    } catch (err) {
      log('avatar upload failed: ${err.runtimeType}');
      if (!ref.mounted) return false;
      state = state.copyWith(
        isUploadingAvatar: false,
        errorMessage: () => "Couldn't update your photo. Please try again.",
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);
}
