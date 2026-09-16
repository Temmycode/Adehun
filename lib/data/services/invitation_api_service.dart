import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/invite_lookup.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'invitation_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class InvitationApiService {
  factory InvitationApiService(Dio dio, {String? baseUrl}) =
      _InvitationApiService;

  /// Public endpoint: works before sign-in.
  @GET(invitationLookupUrl)
  Future<HttpResponse<InviteLookup>> lookup(@Path('token') String token);
}
