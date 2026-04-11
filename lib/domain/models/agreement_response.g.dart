// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementResponse _$AgreementResponseFromJson(Map<String, dynamic> json) =>
    AgreementResponse(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as String?,
      status: json['status'] as String?,
      depositor: AgreementResponse._participantFromJson(
        json['depositor'] as Map<String, dynamic>?,
      ),
      beneficiary: AgreementResponse._participantFromJson(
        json['beneficiary'] as Map<String, dynamic>?,
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AgreementResponseToJson(AgreementResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'amount': instance.amount,
      'status': instance.status,
      'depositor': AgreementResponse._participantToJson(instance.depositor),
      'beneficiary': AgreementResponse._participantToJson(instance.beneficiary),
      'created_at': instance.createdAt?.toIso8601String(),
    };
