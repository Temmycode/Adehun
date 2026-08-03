import 'package:json_annotation/json_annotation.dart';

part 'transaction_summary.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionSummary {
  final String totalCredit;
  final String totalDebit;

  final int creditCount;
  final int debitCount;

  TransactionSummary({
    required this.totalCredit,
    required this.totalDebit,
    required this.creditCount,
    required this.debitCount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionSummaryToJson(this);
}
