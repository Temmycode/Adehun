// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  type: json['type'] as String,
  availableBalance: (json['available_balance'] as num?)?.toDouble() ?? 0.0,
  escrowBalance: (json['escrow_balance'] as num?)?.toDouble() ?? 0.0,
  totalBalance: (json['total_balance'] as num?)?.toDouble() ?? 0.0,
  currency: json['currency'] as String? ?? 'NGN',
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'available_balance': instance.availableBalance,
      'escrow_balance': instance.escrowBalance,
      'total_balance': instance.totalBalance,
      'currency': instance.currency,
    };
