import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/agreement_stats_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'stats_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class StatsApiService {
  factory StatsApiService(Dio dio, {String? baseUrl}) = _StatsApiService;

  @GET(getUserAgreementsStatsUrl)
  Future<HttpResponse<AgreementStatsResponse>> getUserAgreementStats();
}
