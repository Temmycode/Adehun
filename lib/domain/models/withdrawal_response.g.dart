// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalResponse _$WithdrawalResponseFromJson(Map<String, dynamic> json) =>
    WithdrawalResponse(
      reference: json['reference'] as String,
      amount: json['amount'] as String,
      currency: json['currency'] as String? ?? 'NGN',
      status: json['status'] as String,
      bankAccountId: json['bank_account_id'] as String?,
      accountNumber: json['account_number'] as String?,
      bankName: json['bank_name'] as String?,
      availableBalance: json['available_balance'] as String?,
      failureReason: json['failure_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$WithdrawalResponseToJson(WithdrawalResponse instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'bank_account_id': instance.bankAccountId,
      'account_number': instance.accountNumber,
      'bank_name': instance.bankName,
      'available_balance': instance.availableBalance,
      'failure_reason': instance.failureReason,
      'created_at': instance.createdAt?.toIso8601String(),
    };
