import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/transaction.dart';
import 'package:adehun_mvp/domain/models/transaction_list_response.dart';
import 'package:adehun_mvp/domain/models/transaction_summary.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'transaction_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class TransactionApiService {
  factory TransactionApiService(Dio dio, {String? baseUrl}) =
      _TransactionApiService;

  @GET(getTransactionsUrl)
  Future<HttpResponse<TransactionListResponse>> getTransactions(
    @Query("skip") int skip,
    @Query("limit") int? limit,
    @Query("type") List<String>? type,
    @Query("direction") String? direction,
    @Query("status") String? status,
    @Query("agreement_id") String? agreementId,
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo,
    @Query("min_amount") String? minAmount,
    @Query("max_amount") String? maxAmount,
    @Query("search") String? search,
  );

  @GET(getTransactionSummaryUrl)
  Future<HttpResponse<TransactionSummary>> getTransactionSummary();

  @GET(getTransactionsUrl)
  Future<HttpResponse<Transaction>> getTransaction(
    @Path("transaction_id") String transactionId,
  );
}
