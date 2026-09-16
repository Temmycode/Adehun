import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'bank_account_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class BankAccountApiService {
  factory BankAccountApiService(Dio dio, {String? baseUrl}) =
      _BankAccountApiService;

  @GET(listBanksUrl)
  Future<HttpResponse<List<Bank>>> listBanks();

  @POST(resolveBankAccountUrl)
  Future<HttpResponse<ResolvedAccount>> resolveAccount(
    @Body() Map<String, dynamic> body,
  );

  @GET(bankAccountsUrl)
  Future<HttpResponse<List<BankAccount>>> listAccounts();

  @POST(bankAccountsUrl)
  Future<HttpResponse<BankAccount>> addAccount(
    @Body() Map<String, dynamic> body,
  );

  @PATCH(setDefaultBankAccountUrl)
  Future<HttpResponse<BankAccount>> setDefault(
    @Path('account_id') String accountId,
  );

  @DELETE(deleteBankAccountUrl)
  Future<HttpResponse<dynamic>> deleteAccount(
    @Path('account_id') String accountId,
  );
}
