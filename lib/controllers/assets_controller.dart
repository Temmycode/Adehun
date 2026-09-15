import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/domain/states/asset_state.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assets_controller.g.dart';

@Riverpod(keepAlive: true)
class AssetsController extends _$AssetsController {
  @override
  AssetState build() => const AssetState();

  Future<void> getConditionAssets(String conditionId) async {
    final cache = ref.read(localDataCacheManagerProvider);
    final cachedAssets = cache.getCachedAssets(conditionId);

    // Show cached assets immediately; only spin when there is nothing yet.
    state = state.copyWith(
      assets: cachedAssets != null
          ? _withAssets(conditionId, cachedAssets)
          : null,
      isLoading: cachedAssets == null,
      errorMessage: () => null,
    );

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getConditionAssets(conditionId);

      if (dataState is DataSuccess && dataState.data != null) {
        await cache.cacheAssets(conditionId, dataState.data!);

        state = state.copyWith(
          assets: _withAssets(conditionId, dataState.data!),
          isLoading: false,
        );
      } else {
        _finishLoad(
          hasFallback: cachedAssets != null,
          message: _errorText(dataState, 'Failed to load assets'),
        );
      }
    } catch (err) {
      debugPrint('Failed to load assets: $err');
      _finishLoad(
        hasFallback: cachedAssets != null,
        message: 'Failed to load assets',
      );
    }
  }

  Future<UploadSignatureResponse> _getUploadSignature(
    String conditionId,
  ) async {
    final sigDataState = await ref
        .read(conditionRepositoryProvider)
        .getConditionAssetUploadSignature(conditionId);

    if (sigDataState is DataFailed ||
        (sigDataState is DataSuccess && sigDataState.data == null)) {
      throw UploadSignatureError();
    }
    return sigDataState.data!;
  }

  Future<void> uploadConditionAssets(
    String conditionId,
    List<FileResponse> files,
  ) async {
    if (state.isAdding) return;
    state = state.copyWith(isAdding: true, errorMessage: () => null);

    try {
      final cache = ref.read(localDataCacheManagerProvider);
      final repository = ref.read(conditionRepositoryProvider);

      // 1. Fetch signature & upload files
      final signature = await _getUploadSignature(conditionId);
      final uploadFiles = await ref
          .read(cloudinaryUploadServiceProvider)
          .uploadFiles(signature, files);

      // 2. Persist metadata to server
      final dataState = await repository.addConditionAssets(
        conditionId: conditionId,
        files: uploadFiles.map((upload) => upload.toUpload()).toList(),
      );

      if (dataState is DataSuccess && dataState.data != null) {
        // Read the map *after* the uploads — they take long enough that a
        // concurrent fetch may have landed, and a pre-upload snapshot would
        // silently discard it.
        final merged = [...state.assetsFor(conditionId), ...dataState.data!];

        await cache.cacheAssets(conditionId, merged);

        state = state.copyWith(
          assets: _withAssets(conditionId, merged),
          isAdding: false,
        );
        appRouter.pop();
      } else {
        state = state.copyWith(
          isAdding: false,
          errorMessage: () => _errorText(dataState, 'Failed to upload assets'),
        );
      }
    } on UploadSignatureError {
      state = state.copyWith(
        isAdding: false,
        errorMessage: () => 'Could not start the upload. Please try again.',
      );
    } catch (err, stk) {
      debugPrint("Error adding files: $err\n$stk");
      state = state.copyWith(
        isAdding: false,
        errorMessage: () => 'Failed to upload assets',
      );
    }
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);

  /// Current map with [conditionId] swapped for [assets]. Other conditions keep
  /// whatever is already loaded.
  Map<String, List<AssetsResponse>> _withAssets(
    String conditionId,
    List<AssetsResponse> assets,
  ) {
    return {...state.assets, conditionId: assets};
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
