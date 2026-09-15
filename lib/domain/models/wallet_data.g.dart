// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  type: json['type'] as String? ?? 'WALLET_STATE',
  availableBalance: _toDouble(json['available_balance']),
  escrowBalance: _toDouble(json['escrow_balance']),
  totalBalance: _toDouble(json['total_balance']),
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
