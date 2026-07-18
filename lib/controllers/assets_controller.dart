import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/states/asset_state.dart';
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
}
