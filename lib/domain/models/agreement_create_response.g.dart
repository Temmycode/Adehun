// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_create_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementCreateResponse _$AgreementCreateResponseFromJson(
  Map<String, dynamic> json,
) => AgreementCreateResponse(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  amount: json['amount'] as String?,
  status: json['status'] as String?,
  depositor: AgreementCreateResponse._participantFromJson(
    json['depositor'] as Map<String, dynamic>?,
  ),
  beneficiary: AgreementCreateResponse._participantFromJson(
    json['beneficiary'] as Map<String, dynamic>?,
  ),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  conditions: (json['conditions'] as List<dynamic>?)
      ?.map((e) => ConditionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AgreementCreateResponseToJson(
  AgreementCreateResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'amount': instance.amount,
  'status': instance.status,
  'depositor': AgreementCreateResponse._participantToJson(instance.depositor),
  'beneficiary': AgreementCreateResponse._participantToJson(
    instance.beneficiary,
  ),
  'created_at': instance.createdAt?.toIso8601String(),
  'conditions': instance.conditions?.map((e) => e.toJson()).toList(),
};
