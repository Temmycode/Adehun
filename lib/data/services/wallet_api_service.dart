import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'wallet_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class WalletApiService {
  factory WalletApiService(Dio dio, {String? baseUrl}) = _WalletApiService;

  @POST(fundWalletUrl)
  Future<HttpResponse<WalletCodeResponse>> fundWallet(
    @Body() Map<String, dynamic> body,
    @Header('Idempotency-Key') String idempotencyKey,
  );
}
