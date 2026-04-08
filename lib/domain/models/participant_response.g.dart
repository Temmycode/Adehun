// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantResponse _$ParticipantResponseFromJson(Map<String, dynamic> json) =>
    ParticipantResponse(
      id: json['id'] as String?,
      agreementId: json['agreement_id'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      user: json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParticipantResponseToJson(
  ParticipantResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'agreement_id': instance.agreementId,
  'role': instance.role,
  'status': instance.status,
  'user': instance.user,
};
