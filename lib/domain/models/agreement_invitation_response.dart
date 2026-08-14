import 'package:json_annotation/json_annotation.dart';

part 'agreement_invitation_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementInvitationResponse {
  final String? id;
  final String? email;
  final String? role;
  final String? status;
  final DateTime? expiresAt;

  const AgreementInvitationResponse({
    this.id,
    this.email,
    this.role,
    this.status,
    this.expiresAt,
  });

  factory AgreementInvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreementInvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementInvitationResponseToJson(this);
}
