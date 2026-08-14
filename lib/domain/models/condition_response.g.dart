// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConditionResponse _$ConditionResponseFromJson(Map<String, dynamic> json) =>
    ConditionResponse(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      createdByParticipant: json['created_by_participant'] == null
          ? null
          : ParticipantResponse.fromJson(
              json['created_by_participant'] as Map<String, dynamic>,
            ),
      requiredFromParticipant: json['required_from_participant'] == null
          ? null
          : ParticipantResponse.fromJson(
              json['required_from_participant'] as Map<String, dynamic>,
            ),
      invitation: json['invitation'] == null
          ? null
          : AgreementInvitationResponse.fromJson(
              json['invitation'] as Map<String, dynamic>,
            ),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      rejectedReason: json['rejected_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      agreementId: json['agreement_id'] as String?,
    );

Map<String, dynamic> _$ConditionResponseToJson(ConditionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'created_by_participant': instance.createdByParticipant,
      'required_from_participant': instance.requiredFromParticipant,
      'invitation': instance.invitation,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'rejected_reason': instance.rejectedReason,
      'created_at': instance.createdAt?.toIso8601String(),
      'agreement_id': instance.agreementId,
    };
