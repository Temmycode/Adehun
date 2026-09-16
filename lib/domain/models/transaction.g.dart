// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: json['id'] as String,
  reference: json['reference'] as String,
  type: $enumDecode(
    _$TransactionTypeEnumMap,
    json['type'],
    unknownValue: TransactionType.unknown,
  ),
  direction: $enumDecode(
    _$TransactionDirectionEnumMap,
    json['direction'],
    unknownValue: TransactionDirection.unknown,
  ),
  status: $enumDecode(
    _$TransactionStatusEnumMap,
    json['status'],
    unknownValue: TransactionStatus.unknown,
  ),
  amount: json['amount'] as String,
  currency: json['currency'] as String,
  balanceAfter: json['balance_after'] as String,
  escrowAfter: json['escrow_after'] as String,
  description: json['description'] as String?,
  agreementId: json['agreement_id'] as String?,
  conditionId: json['condition_id'] as String?,
  counterpartyUserId: json['counterparty_user_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  processedAt: json['processed_at'] == null
      ? null
      : DateTime.parse(json['processed_at'] as String),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'direction': _$TransactionDirectionEnumMap[instance.direction]!,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'balance_after': instance.balanceAfter,
      'escrow_after': instance.escrowAfter,
      'description': instance.description,
      'agreement_id': instance.agreementId,
      'condition_id': instance.conditionId,
      'counterparty_user_id': instance.counterpartyUserId,
      'created_at': instance.createdAt.toIso8601String(),
      'processed_at': instance.processedAt?.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.deposit: 'deposit',
  TransactionType.escrowLock: 'escrow_lock',
  TransactionType.escrowReleaseOut: 'escrow_release_out',
  TransactionType.escrowReleaseIn: 'escrow_release_in',
  TransactionType.escrowRefund: 'escrow_refund',
  TransactionType.withdrawal: 'withdrawal',
  TransactionType.withdrawalReversal: 'withdrawal_reversal',
  TransactionType.adjustmentCredit: 'adjustment_credit',
  TransactionType.adjustmentDebit: 'adjustment_debit',
  TransactionType.unknown: 'unknown',
};

const _$TransactionDirectionEnumMap = {
  TransactionDirection.credit: 'credit',
  TransactionDirection.debit: 'debit',
  TransactionDirection.unknown: 'unknown',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.completed: 'completed',
  TransactionStatus.reversed: 'reversed',
  TransactionStatus.unknown: 'unknown',
};
