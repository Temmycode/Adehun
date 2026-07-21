import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/domain/states/asset_state.dart';
import 'package:adehun_mvp/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assets_controller.g.dart';

@Riverpod(keepAlive: true)
class AssetsController extends _$AssetsController {
  @override
  FutureOr<AssetState> build() {
    return AssetState();
  }

  Future<void> getConditionAssets(String conditionId) async {
    final currentState = state.value ?? const AssetState();
    final cache = ref.read(localDataCacheManagerProvider);
    final cachedAssets = cache.getCachedAssets(conditionId);

    if (cachedAssets != null) {
      final updatedAssets = Map<String, List<AssetsResponse>>.from(
        currentState.assets,
      )..[conditionId] = cachedAssets;

      state = AsyncData(currentState.copyWith(assets: updatedAssets));
    } else {
      state = const AsyncLoading();
    }

    try {
      final dataState = await ref
          .read(conditionRepositoryProvider)
          .getConditionAssets(conditionId);

      if (dataState is DataSuccess && dataState.data != null) {
        await cache.cacheAssets(conditionId, dataState.data!);

        final updatedAssets = Map<String, List<AssetsResponse>>.from(
          currentState.assets,
        )..[conditionId] = dataState.data!;

        state = AsyncData(currentState.copyWith(assets: updatedAssets));
      } else if (cachedAssets == null) {
        state = AsyncData(currentState);
      }
    } catch (err, stk) {
      if (cachedAssets == null) {
        state = AsyncValue.error(err, stk);
      }
    }
  }

  Future<UploadSignatureResponse> _getUploadSignature(
    String conditionId,
  ) async {
    try {
      final sigDataState = await ref
          .read(conditionRepositoryProvider)
          .getConditionAssetUploadSignature(conditionId);

      if (sigDataState is DataFailed ||
          (sigDataState is DataSuccess && sigDataState.data == null)) {
        throw UploadSignatureError();
      }
      return sigDataState.data!;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<FileResponse>> _uploadFiles(
    UploadSignatureResponse signature,
    List<FileResponse> files,
  ) async {
    try {
      final cloudName = signature.cloudName;
      if (cloudName.isEmpty) {
        throw ArgumentError('cloudName is missing in SignedUpload');
      }

      final results = <FileResponse>[];
      final cloudinaryDio = Dio(
        BaseOptions(validateStatus: (status) => status != null && status < 500),
      );

      for (final file in files) {
        if (file.path == null || file.path!.isEmpty) {
          throw ArgumentError('File path is required for upload');
        }

        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path!, filename: file.name),
          'folder': signature.folder,
          'timestamp': signature.timestamp,
          'signature': signature.signature,
          'api_key': signature.apiKey,
        });

        final uploadUrl =
            'https://api.cloudinary.com/v1_1/$cloudName/auto/upload';
        final response = await cloudinaryDio.post(uploadUrl, data: formData);

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error:
                'Cloudinary upload failed: ${response.statusCode} - ${response.data}',
            type: DioExceptionType.badResponse,
          );
        }

        final uploadedUrl =
            response.data['secure_url'] ?? response.data['secureUrl'];
        if (uploadedUrl == null ||
            uploadedUrl is! String ||
            uploadedUrl.isEmpty) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Cloudinary upload returned no secure URL',
            type: DioExceptionType.badResponse,
          );
        }

        results.add(file.copyWith(url: uploadedUrl));
      }

      print(results);
      return results;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> uploadConditionAssets(
    String conditionId,
    List<FileResponse> files,
  ) async {
    final currentState = state.value ?? const AssetState();

    // Set loading sub-state
    state = AsyncData(currentState.copyWith(isAdding: true));

    try {
      final cache = ref.read(localDataCacheManagerProvider);
      final repository = ref.read(conditionRepositoryProvider);

      // 1. Fetch signature & upload files
      final signature = await _getUploadSignature(conditionId);
      final uploadFiles = await _uploadFiles(signature, files);

      // 2. Persist metadata to server
      final dataState = await repository.addConditionAssets(
        conditionId: conditionId,
        files: uploadFiles.map((upload) => upload.toUpload()).toList(),
      );

      if (dataState is DataSuccess && dataState.data != null) {
        final newAssetsList = dataState.data!;
        final currentMap = currentState.assets;

        // Immutable map update
        final updatedAssetsMap = Map<String, List<AssetsResponse>>.from(
          currentMap,
        )..[conditionId] = [...?currentMap[conditionId], ...newAssetsList];

        // Update local cache with the newly updated list for this condition
        await cache.cacheAssets(conditionId, updatedAssetsMap[conditionId]!);

        // Update state & turn off loading flag
        state = AsyncData(
          currentState.copyWith(isAdding: false, assets: updatedAssetsMap),
        );
        appRouter.pop();
      } else {
        // Handle server failure (DataFailed)
        state = AsyncData(currentState.copyWith(isAdding: false));
        // Trigger UI side effect / snackbar notification here
      }
    } on UploadSignatureError catch (_) {
      state = AsyncData(currentState.copyWith(isAdding: false));
      // Trigger UI snackbar for signature error
    } catch (err, stk) {
      debugPrint("Error adding files: $err\n$stk");
      // Ensure isAdding drops to false on unhandled errors
      state = AsyncData(currentState.copyWith(isAdding: false));
      // Optional: emit error state or rethrow depending on UI requirement
    }
  }
}
