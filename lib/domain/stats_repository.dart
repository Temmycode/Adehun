import 'package:adehun_mvp/domain/models/agreement_stats_response.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';

abstract class StatsRepository {
  Future<DataState<AgreementStatsResponse>> getUserAgreementStats();
}
