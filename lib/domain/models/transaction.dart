import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

/// Maps directly to the backend's snake_case values
@JsonEnum(fieldRename: FieldRename.snake)
enum TransactionDirection { credit, debit }

/// Maps Python's LedgerEntryType(StrEnum)
@JsonEnum(fieldRename: FieldRename.snake)
enum TransactionType {
  deposit,
  escrowLock,
  escrowReleaseOut,
  escrowReleaseIn,
  escrowRefund,
  withdrawal,
  withdrawalReversal,
  adjustmentCredit,
  adjustmentDebit,
}

/// Maps Python's LedgerEntryStatus(StrEnum)
@JsonEnum(fieldRename: FieldRename.snake)
enum TransactionStatus { pending, completed, reversed }

@JsonSerializable(fieldRename: FieldRename.snake)
class Transaction {
  final String id;
  final String reference;
  final TransactionType type;
  final TransactionDirection direction;
  final TransactionStatus status;

  final String amount;
  final String currency;
  final String balanceAfter;
  final String escrowAfter;

  final String? description;
  final String? agreementId;
  final String? conditionId;
  final String? counterpartyUserId;
  final DateTime createdAt;
  final DateTime? processedAt;

  const Transaction({
    required this.id,
    required this.reference,
    required this.type,
    required this.direction,
    required this.status,
    required this.amount,
    required this.currency,
    required this.balanceAfter,
    required this.escrowAfter,
    required this.description,
    required this.agreementId,
    required this.conditionId,
    required this.counterpartyUserId,
    required this.createdAt,
    required this.processedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
