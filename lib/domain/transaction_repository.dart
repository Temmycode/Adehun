import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/transaction.dart';
import 'package:adehun_mvp/domain/models/transaction_list_response.dart';
import 'package:adehun_mvp/domain/models/transaction_summary.dart';

abstract class TransactionRepository {
  Future<DataState<Transaction>> getTransaction(String transactionId);

  Future<DataState<TransactionListResponse>> getTransactions({
    int skip = 0,
    int? limit,
    List<String>? type,
    String? direction,
    String? status,
    String? agreementId,
    String? dateFrom,
    String? dateTo,
    String? minAmount,
    String? maxAmount,
    String? search,
  });

  Future<DataState<TransactionSummary>> getTransactionSummary();
}
