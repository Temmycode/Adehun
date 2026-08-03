import 'dart:developer' show log;
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/data/services/transaction_api_service.dart';
import 'package:adehun_mvp/domain/models/transaction.dart';
import 'package:adehun_mvp/domain/models/transaction_list_response.dart';
import 'package:adehun_mvp/domain/models/transaction_summary.dart';
import 'package:adehun_mvp/domain/transaction_repository.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class TransactionRepoImpl implements TransactionRepository {
  final TransactionApiService _transApiService;

  const TransactionRepoImpl({required TransactionApiService apiService})
    : _transApiService = apiService;

  @override
  Future<DataState<Transaction>> getTransaction(String transactionId) async {
    try {
      final apiResponse = await _transApiService.getTransaction(transactionId);

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(TransactionNotFoundError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
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
  }) async {
    try {
      final apiResponse = await _transApiService.getTransactions(
        skip,
        limit,
        type,
        direction,
        status,
        agreementId,
        dateFrom,
        dateTo,
        minAmount,
        maxAmount,
        search,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(TransactionListNotFoundError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<TransactionSummary>> getTransactionSummary() async {
    try {
      final apiResponse = await _transApiService.getTransactionSummary();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(TransactionSummaryNotFoundError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
