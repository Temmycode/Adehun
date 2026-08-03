import 'package:flutter/foundation.dart' show immutable, listEquals;

import 'package:adehun_mvp/domain/models/transaction.dart';
import 'package:adehun_mvp/domain/models/transaction_summary.dart';

@immutable
class TransactionState {
  final List<Transaction> transactions;
  final TransactionSummary? summary;
  final Transaction? selectedTransaction;

  /// Total the server reports, used to know when pagination is exhausted.
  final int total;

  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  const TransactionState({
    this.transactions = const [],
    this.summary,
    this.selectedTransaction,
    this.total = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  bool get hasMore => transactions.length < total;

  TransactionState copyWith({
    List<Transaction>? transactions,
    TransactionSummary? Function()?
    summary, // Function wrap allows passing explicit null
    Transaction? Function()? selectedTransaction,
    int? total,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? errorMessage,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      summary: summary != null ? summary() : this.summary,
      selectedTransaction: selectedTransaction != null
          ? selectedTransaction()
          : this.selectedTransaction,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  bool operator ==(covariant TransactionState other) {
    if (identical(this, other)) return true;

    return listEquals(other.transactions, transactions) &&
        other.summary == summary &&
        other.selectedTransaction == selectedTransaction &&
        other.total == total &&
        other.isLoading == isLoading &&
        other.isLoadingMore == isLoadingMore &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(transactions),
      summary,
      selectedTransaction,
      total,
      isLoading,
      isLoadingMore,
      errorMessage,
    );
  }

  @override
  String toString() {
    return 'TransactionState(transactions: ${transactions.length}/$total, '
        'summary: $summary, selectedTransaction: $selectedTransaction, '
        'isLoading: $isLoading, isLoadingMore: $isLoadingMore, '
        'errorMessage: $errorMessage)';
  }
}
