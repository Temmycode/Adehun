import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/data/services/stats_api_service.dart';
import 'package:adehun_mvp/domain/models/agreement_stats_response.dart';
import 'package:adehun_mvp/domain/stats_repository.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:flutter/foundation.dart';

class StatsRepoImpl implements StatsRepository {
  final StatsApiService _statsApiService;
  const StatsRepoImpl(StatsApiService apiService)
      : _statsApiService = apiService;

  @override
  Future<DataState<AgreementStatsResponse>> getUserAgreementStats() async {
    try {
      final apiResponse = await _statsApiService.getUserAgreementStats();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetAgreementStatsError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
