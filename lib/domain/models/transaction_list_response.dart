import 'package:json_annotation/json_annotation.dart';

// Import your existing models (adjust the paths as needed)
import 'transaction.dart';
import 'transaction_summary.dart';

part 'transaction_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionListResponse {
  final List<Transaction> transactions;
  final int total;
  final int skip;
  final int limit;
  final TransactionSummary summary;

  const TransactionListResponse({
    required this.transactions,
    required this.total,
    required this.skip,
    required this.limit,
    required this.summary,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionListResponseToJson(this);
}
