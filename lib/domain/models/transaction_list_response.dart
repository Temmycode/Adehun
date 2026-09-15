import 'package:json_annotation/json_annotation.dart';

import 'transaction.dart';
import 'transaction_summary.dart';

part 'transaction_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionListResponse {
  final List<Transaction> transactions;
  final int total;
  final int skip;
  final int limit;

  /// Nullable on the wire (`exclude_none` drops it when the server has none).
  final TransactionSummary? summary;

  const TransactionListResponse({
    required this.transactions,
    required this.total,
    required this.skip,
    required this.limit,
    this.summary,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionListResponseToJson(this);
}
