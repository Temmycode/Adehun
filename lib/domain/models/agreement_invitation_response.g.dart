// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_invitation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementInvitationResponse _$AgreementInvitationResponseFromJson(
  Map<String, dynamic> json,
) => AgreementInvitationResponse(
  id: json['id'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  status: json['status'] as String?,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$AgreementInvitationResponseToJson(
  AgreementInvitationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'role': instance.role,
  'status': instance.status,
  'expires_at': instance.expiresAt?.toIso8601String(),
};
