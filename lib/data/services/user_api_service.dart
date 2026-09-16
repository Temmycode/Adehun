import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/upload_signature_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) = _UserApiService;

  @GET(currentUserUrl)
  Future<HttpResponse<UserData>> getCurrentUser();

  @PATCH(updateUserUrl)
  Future<HttpResponse<UserData>> updateUser(
    @Path('user_id') String userId,
    @Body() Map<String, dynamic> body,
  );

  @GET(profileUploadSignatureUrl)
  Future<HttpResponse<UploadSignatureResponse>> getProfileUploadSignature();
}
