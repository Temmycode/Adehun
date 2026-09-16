// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escrow_movement_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EscrowMovementResponse _$EscrowMovementResponseFromJson(
  Map<String, dynamic> json,
) => EscrowMovementResponse(
  agreementId: json['agreement_id'] as String,
  amount: json['amount'] as String,
  reference: json['reference'] as String,
  availableBalance: json['available_balance'] as String,
  escrowBalance: json['escrow_balance'] as String,
  replayed: json['replayed'] as bool? ?? false,
);

Map<String, dynamic> _$EscrowMovementResponseToJson(
  EscrowMovementResponse instance,
) => <String, dynamic>{
  'agreement_id': instance.agreementId,
  'amount': instance.amount,
  'reference': instance.reference,
  'available_balance': instance.availableBalance,
  'escrow_balance': instance.escrowBalance,
  'replayed': instance.replayed,
};
