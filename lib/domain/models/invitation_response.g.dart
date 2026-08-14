// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationResponse _$InvitationResponseFromJson(Map<String, dynamic> json) =>
    InvitationResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      agreement: AgreementResponse.fromJson(
        json['agreement'] as Map<String, dynamic>,
      ),
      role: json['role'] as String,
      invitedByUser: UserData.fromJson(
        json['invited_by_user'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$InvitationResponseToJson(InvitationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'token': instance.token,
      'agreement': instance.agreement,
      'role': instance.role,
      'invited_by_user': instance.invitedByUser,
      'status': instance.status,
      'expires_at': instance.expiresAt.toIso8601String(),
    };
