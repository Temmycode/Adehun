import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/login_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST(loginUrl)
  Future<HttpResponse<LoginResponse>> googleSignIn(
    @Body() Map<String, dynamic> body,
  );

  @POST(registerUrl)
  Future<HttpResponse<UserData>> registerUser(
    @Body() Map<String, dynamic> body,
  );

  @POST(registerFromInviteUrl)
  Future<HttpResponse<LoginResponse>> registerFromInvite(
    @Body() Map<String, dynamic> body,
  );
}
