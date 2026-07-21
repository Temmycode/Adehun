import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/agreement_create_response.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'agreement_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class AgreementApiService {
  factory AgreementApiService(Dio dio, {String? baseUrl}) =
      _AgreementApiService;

  @GET(getAllUserAgreementUrl)
  Future<HttpResponse<List<AgreementResponse>>> getAllUserAgreements();

  @POST(addAgreementUrl)
  Future<HttpResponse<AgreementCreateResponse>> createAgreement(
    @Body() Map<String, dynamic> body,
  );

  @POST(acceptAgreementUrl)
  Future<HttpResponse<AgreementResponse>> acceptAgreement(
    @Path("agreement_id") String agreementId,
  );

  @POST(addAgreementUrl)
  Future<HttpResponse<AgreementResponse>> rejectAgreement(
    @Path("agreement_id") String agreementId,
  );

  @GET(getAgreementUrl)
  Future<HttpResponse<AgreementResponse>> getAgreement(
    @Path("agreement_id") String agreementId,
  );

  @GET(getAgreementInvitationUrl)
  Future<HttpResponse<InvitationResponse>> getAgreementInvitation(
    @Path("agreement_id") String agreementId,
  );
}
