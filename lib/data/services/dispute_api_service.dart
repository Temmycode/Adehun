import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'dispute_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class DisputeApiService {
  factory DisputeApiService(Dio dio, {String? baseUrl}) = _DisputeApiService;

  @GET(getDisputeUploadSignatureUrl)
  Future<HttpResponse<UploadSignatureResponse>> getDisputeUploadSignature(
    @Path('agreement_id') String agreementId,
  );

  @POST(raiseDisputeUrl)
  Future<HttpResponse<DisputeResponse>> raiseDispute(
    @Path('agreement_id') String agreementId,
    @Body() Map<String, dynamic> body,
  );

  @GET(getAgreementDisputesUrl)
  Future<HttpResponse<List<DisputeResponse>>> getAgreementDisputes(
    @Path('agreement_id') String agreementId,
  );
}
