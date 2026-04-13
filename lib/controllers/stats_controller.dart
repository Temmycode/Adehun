import 'package:adehun_mvp/domain/models/agreement_stats_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/service_locator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_controller.g.dart';

@Riverpod(keepAlive: true)
class StatsController extends _$StatsController {
  @override
  FutureOr<AgreementStatsResponse> build() async {
    return await _getUserAgreementStats();
  }

  Future<AgreementStatsResponse> _getUserAgreementStats() async {
    const initialState = AgreementStatsResponse.empty();

    try {
      final dataState = await ref
          .read(statsRepositoryProvider)
          .getUserAgreementStats();

      if (dataState is DataSuccess && dataState.data != null) {
        return dataState.data ?? initialState;
      }

      return initialState;
    } catch (e) {
      return initialState;
    }
  }

  Future<void> refresh() async {
    final currentState = state.value ?? AgreementStatsResponse.empty();

    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final dataState = await ref
          .read(statsRepositoryProvider)
          .getUserAgreementStats();

      if (dataState is DataSuccess && dataState.data != null) {
        return dataState.data ?? currentState;
      }

      return currentState;
    });
  }
}
