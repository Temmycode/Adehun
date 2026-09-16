import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/wallet_code_response.dart';
import 'package:adehun_mvp/domain/models/wallet_data.dart';
import 'package:adehun_mvp/domain/models/withdrawal_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'wallet_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class WalletApiService {
  factory WalletApiService(Dio dio, {String? baseUrl}) = _WalletApiService;

  /// Source of truth for balances. The websocket is an optimisation on top.
  @GET(getWalletUrl)
  Future<HttpResponse<WalletData>> getWallet();

  @POST(fundWalletUrl)
  Future<HttpResponse<WalletCodeResponse>> fundWallet(
    @Body() Map<String, dynamic> body,
    @Header('Idempotency-Key') String idempotencyKey,
  );

  @POST(withdrawUrl)
  Future<HttpResponse<WithdrawalResponse>> withdraw(
    @Body() Map<String, dynamic> body,
    @Header('Idempotency-Key') String idempotencyKey,
  );

  @GET(getWithdrawalUrl)
  Future<HttpResponse<WithdrawalResponse>> getWithdrawal(
    @Path('reference') String reference,
  );
}
