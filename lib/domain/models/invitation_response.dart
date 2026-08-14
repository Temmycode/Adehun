import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invitation_response.g.dart';

@JsonSerializable(fieldRename: .snake)
class InvitationResponse {
  final String id;
  final String email;
  final String token;
  final AgreementResponse agreement;
  final String role;
  final UserData invitedByUser;
  final String status;
  final DateTime expiresAt;

  const InvitationResponse({
    required this.id,
    required this.email,
    required this.token,
    required this.agreement,
    required this.role,
    required this.invitedByUser,
    required this.status,
    required this.expiresAt,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationResponseToJson(this);
}
