// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_lookup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteLookup _$InviteLookupFromJson(Map<String, dynamic> json) => InviteLookup(
  agreementId: json['agreement_id'] as String,
  agreementTitle: json['agreement_title'] as String? ?? '',
  inviterName: json['inviter_name'] as String? ?? 'Someone',
  role: json['role'] as String? ?? '',
  status: json['status'] as String? ?? 'pending',
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  emailHint: json['email_hint'] as String? ?? '',
);

Map<String, dynamic> _$InviteLookupToJson(InviteLookup instance) =>
    <String, dynamic>{
      'agreement_id': instance.agreementId,
      'agreement_title': instance.agreementTitle,
      'inviter_name': instance.inviterName,
      'role': instance.role,
      'status': instance.status,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'email_hint': instance.emailHint,
    };
