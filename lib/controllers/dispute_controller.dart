import 'dart:developer';

import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/network/api_error_handler.dart';
import 'package:adehun_mvp/core/network/api_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/domain/states/dispute_state.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dispute_controller.g.dart';

@Riverpod(keepAlive: true)
class DisputeController extends _$DisputeController {
  @override
  DisputeState build() => const DisputeState();

  Future<void> getAgreementDisputes(String agreementId) async {
    final cache = ref.read(localDataCacheManagerProvider);
    final cachedDisputes = cache.getCachedDisputes(agreementId);

    // Show cached disputes immediately; only spin when there is nothing yet.
    state = state.copyWith(
      disputes: cachedDisputes != null
          ? _withDisputes(agreementId, cachedDisputes)
          : null,
      isLoading: cachedDisputes == null,
      errorMessage: () => null,
    );

    try {
      final dataState = await ref
          .read(disputeRepositoryProvider)
          .getAgreementDisputes(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        await cache.cacheDisputes(agreementId, dataState.data!);

        state = state.copyWith(
          disputes: _withDisputes(agreementId, dataState.data!),
          isLoading: false,
        );
      } else {
        _finishLoad(
          hasFallback: cachedDisputes != null,
          message: _errorText(dataState, 'Failed to load disputes'),
        );
      }
    } catch (err) {
      log('Failed to load disputes: $err');
      _finishLoad(
        hasFallback: cachedDisputes != null,
        message: 'Failed to load disputes',
      );
    }
  }

  Future<void> refresh(String agreementId) async {
    state = state.copyWith(
      isLoading: state.disputesFor(agreementId).isEmpty,
      errorMessage: () => null,
    );

    try {
      final dataState = await ref
          .read(disputeRepositoryProvider)
          .getAgreementDisputes(agreementId);

      if (dataState is DataSuccess && dataState.data != null) {
        await ref
            .read(localDataCacheManagerProvider)
            .cacheDisputes(agreementId, dataState.data!);

        state = state.copyWith(
          disputes: _withDisputes(agreementId, dataState.data!),
          isLoading: false,
        );
      } else {
        _finishLoad(
          hasFallback: state.disputesFor(agreementId).isNotEmpty,
          message: _errorText(dataState, 'Failed to load disputes'),
        );
      }
    } catch (err) {
      log('Failed to refresh disputes: $err');
      _finishLoad(
        hasFallback: state.disputesFor(agreementId).isNotEmpty,
        message: 'Failed to load disputes',
      );
    }
  }

  /// Uploads any evidence, then raises the dispute.
  ///
  /// Returns whether it succeeded, so the screen owns what happens next —
  /// it needs to refresh the agreement and pop, not just pop.
  Future<bool> raiseDispute({
    required String agreementId,
    required DisputeCategory category,
    required String description,
    required List<FileResponse> files,
  }) async {
    if (state.isRaising) return false;
    state = state.copyWith(isRaising: true, errorMessage: () => null);

    try {
      final cache = ref.read(localDataCacheManagerProvider);
      final repository = ref.read(disputeRepositoryProvider);

      // 1. Upload evidence, if there is any. No files means no signature is
      // needed, so skip that round trip entirely.
      var uploadedFiles = const <FileResponse>[];
      if (files.isNotEmpty) {
        final signature = await _getUploadSignature(agreementId);
        uploadedFiles = await ref
            .read(cloudinaryUploadServiceProvider)
            .uploadFiles(signature, files);
      }

      // 2. Raise the dispute with the resulting file metadata.
      final dataState = await repository.raiseDispute(
        agreementId: agreementId,
        category: category,
        description: description,
        files: uploadedFiles.map((upload) => upload.toUpload()).toList(),
      );

      if (dataState is DataSuccess && dataState.data != null) {
        // Read the map *after* the uploads — they take long enough that a
        // concurrent fetch may have landed, and a pre-upload snapshot would
        // silently discard it.
        final merged = [dataState.data!, ...state.disputesFor(agreementId)];

        await cache.cacheDisputes(agreementId, merged);

        state = state.copyWith(
          disputes: _withDisputes(agreementId, merged),
          isRaising: false,
        );
        return true;
      }

      state = state.copyWith(
        isRaising: false,
        errorMessage: () => _errorText(dataState, 'Failed to raise dispute'),
      );
      return false;
    } on GetDisputeUploadSignatureError {
      state = state.copyWith(
        isRaising: false,
        errorMessage: () => 'Could not start the upload. Please try again.',
      );
      return false;
    } on DioException catch (err) {
      // The repo rethrows, so a 409 ("a dispute is already live on this
      // agreement") or a 422 arrives here with the envelope's ApiError already
      // attached by ApiResponseInterceptor. Surface the server's own wording
      // rather than a generic failure.
      final apiError = err.error;
      state = state.copyWith(
        isRaising: false,
        errorMessage: () => apiError is ApiError
            ? handleApiError(apiError)
            : 'Failed to raise dispute',
      );
      return false;
    } catch (err, stk) {
      log("Error raising dispute: $err\n$stk");
      state = state.copyWith(
        isRaising: false,
        errorMessage: () => 'Failed to raise dispute',
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);

  Future<UploadSignatureResponse> _getUploadSignature(
    String agreementId,
  ) async {
    final sigDataState = await ref
        .read(disputeRepositoryProvider)
        .getDisputeUploadSignature(agreementId);

    if (sigDataState is DataFailed ||
        (sigDataState is DataSuccess && sigDataState.data == null)) {
      throw GetDisputeUploadSignatureError();
    }
    return sigDataState.data!;
  }

  /// Current map with [agreementId] swapped for [disputes]. Other agreements
  /// keep whatever is already loaded.
  Map<String, List<DisputeResponse>> _withDisputes(
    String agreementId,
    List<DisputeResponse> disputes,
  ) {
    return {...state.disputes, agreementId: disputes};
  }

  void _finishLoad({required bool hasFallback, required String message}) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: hasFallback ? null : () => message,
    );
  }

  String _errorText(DataState dataState, String fallback) =>
      dataState.exception?.toString() ?? fallback;
}
