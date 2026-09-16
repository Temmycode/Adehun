// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bank _$BankFromJson(Map<String, dynamic> json) => Bank(
  name: json['name'] as String,
  code: json['code'] as String,
  currency: json['currency'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
  'name': instance.name,
  'code': instance.code,
  'currency': instance.currency,
  'type': instance.type,
};

ResolvedAccount _$ResolvedAccountFromJson(Map<String, dynamic> json) =>
    ResolvedAccount(
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      bankCode: json['bank_code'] as String,
      bankName: json['bank_name'] as String,
    );

Map<String, dynamic> _$ResolvedAccountToJson(ResolvedAccount instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
    };

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
  id: json['id'] as String,
  accountNumber: json['account_number'] as String,
  accountName: json['account_name'] as String,
  bankCode: json['bank_code'] as String,
  bankName: json['bank_name'] as String,
  currency: json['currency'] as String? ?? 'NGN',
  isDefault: json['is_default'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
      'currency': instance.currency,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt?.toIso8601String(),
    };
