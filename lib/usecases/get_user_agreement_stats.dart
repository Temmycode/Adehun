import 'dart:async';

import 'package:adehun_mvp/domain/models/agreement_stats_response.dart';
import 'package:adehun_mvp/domain/stats_repository.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/resources/usecase.dart';

class GetUserAgreementStatsUseCase
    implements UseCase<DataState<AgreementStatsResponse>, void> {
  final StatsRepository statsRepository;

  GetUserAgreementStatsUseCase(this.statsRepository);

  @override
  Future<DataState<AgreementStatsResponse>> call({void params}) async {
    return await statsRepository.getUserAgreementStats();
  }
}
