// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletCodeResponse _$WalletCodeResponseFromJson(Map<String, dynamic> json) =>
    WalletCodeResponse(
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String? ?? '',
      authorizationUrl: json['authorization_url'] as String?,
      amount: json['amount'] as String? ?? '0',
    );

Map<String, dynamic> _$WalletCodeResponseToJson(WalletCodeResponse instance) =>
    <String, dynamic>{
      'access_code': instance.accessCode,
      'reference': instance.reference,
      'authorization_url': instance.authorizationUrl,
      'amount': instance.amount,
    };
