import 'dart:developer' show log;

import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/states/transaction_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_controller.g.dart';

@Riverpod(keepAlive: true)
class TransactionsListController extends _$TransactionsListController {
  static const _pageSize = 20;

  @override
  TransactionState build() => const TransactionState();

  /// First page. Keeps whatever is already on screen while it refetches, so a
  /// reload doesn't blank the list.
  Future<void> loadTransactions() async {
    if (state.isLoading) return;
    state = state.copyWith(
      isLoading: state.transactions.isEmpty,
      errorMessage: () => null,
    );

    try {
      final dataState = await ref
          .read(transactionRepositoryProvider)
          .getTransactions(skip: 0, limit: _pageSize);

      final page = dataState.data;

      if (dataState is DataSuccess && page != null) {
        state = state.copyWith(
          transactions: page.transactions,
          summary: () => page.summary,
          total: page.total,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: state.transactions.isEmpty
              ? () => _errorText(dataState, 'Failed to load transactions')
              : null,
        );
      }
    } catch (err) {
      log('Failed to load transactions: $err');
      state = state.copyWith(
        isLoading: false,
        errorMessage: state.transactions.isEmpty
            ? () => 'Failed to load transactions'
            : null,
      );
    }
  }

  Future<void> refresh() => loadTransactions();

  /// Appends the next page. No-op once every transaction is loaded.
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final skip = state.transactions.length;
    state = state.copyWith(isLoadingMore: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(transactionRepositoryProvider)
          .getTransactions(skip: skip, limit: _pageSize);

      final page = dataState.data;

      if (dataState is DataSuccess && page != null) {
        // Read the list *after* the await — a refresh may have landed while
        // this page was in flight.
        state = state.copyWith(
          transactions: [...state.transactions, ...page.transactions],
          summary: () => page.summary,
          total: page.total,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: () =>
              _errorText(dataState, 'Failed to load more transactions'),
        );
      }
    } catch (err) {
      log('Failed to load more transactions: $err');
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: () => 'Failed to load more transactions',
      );
    }
  }

  Future<void> getTransaction(String transactionId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final dataState = await ref
          .read(transactionRepositoryProvider)
          .getTransaction(transactionId);

      if (dataState is DataSuccess && dataState.data != null) {
        final transaction = dataState.data!;

        state = state.copyWith(
          selectedTransaction: () => transaction,
          transactions: state.transactions
              .map((t) => t.id == transaction.id ? transaction : t)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () =>
              _errorText(dataState, 'Failed to load transaction'),
        );
      }
    } catch (err) {
      log('Failed to load transaction: $err');
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load transaction',
      );
    }
  }

  /// The list endpoint already returns a summary; this is for screens that want
  /// the totals without pulling a page of transactions.
  Future<void> getTransactionSummary() async {
    try {
      final dataState = await ref
          .read(transactionRepositoryProvider)
          .getTransactionSummary();

      if (dataState is DataSuccess && dataState.data != null) {
        state = state.copyWith(summary: () => dataState.data!);
      } else {
        state = state.copyWith(
          errorMessage: () =>
              _errorText(dataState, 'Failed to load transaction summary'),
        );
      }
    } catch (err) {
      log('Failed to load transaction summary: $err');
      state = state.copyWith(
        errorMessage: () => 'Failed to load transaction summary',
      );
    }
  }

  void clearError() => state = state.copyWith(errorMessage: () => null);

  String _errorText(DataState dataState, String fallback) =>
      dataState.exception?.toString() ?? fallback;
}
