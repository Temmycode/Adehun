import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'condition_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class ConditionApiService {
  factory ConditionApiService(Dio dio, {String? baseUrl}) =
      _ConditionApiService;

  @POST(addConditionToAgreementUrl)
  Future<HttpResponse<ConditionResponse>> addConditionToAgreement(
    @Path('agreement_id') String agreementId,
    @Body() Map<String, dynamic> body,
  );

  @GET(getUserConditionsUrl)
  Future<HttpResponse<List<ConditionResponse>>> getAgreementConditions(
    @Path('agreement_id') String agreementId,
  );

  @GET(getConditionDetailsUrl)
  Future<HttpResponse<ConditionResponse>> getConditionDetails(
    @Path('condition_id') String conditionId,
  );

  @POST(approveConditionUrl)
  Future<HttpResponse<ConditionResponse>> approveCondition(
    @Path('condition_id') String conditionid,
  );

  @POST(rejectConditionUrl)
  Future<HttpResponse<ConditionResponse>> rejectCondition(
    @Path('condition_id') String conditionId,
    @Body() Map<String, dynamic> body,
  );

  @GET(getConditionAssetsUrl)
  Future<HttpResponse<List<AssetsResponse>>> getConditionAssets(
    @Path('condition_id') String conditionId,
  );

  @POST(getConditionAssetsUrl)
  Future<HttpResponse<List<AssetsResponse>>> addConditionAssets(
    @Path('condition_id') String conditionId,
    @Body() Map<String, dynamic> body,
  );

  @GET(getConditionAssetUploadSignatureUrl)
  Future<HttpResponse<UploadSignatureResponse>>
  getConditionAssetUploadSignature(@Path('condition_id') String conditionId);
}
