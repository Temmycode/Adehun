import 'package:json_annotation/json_annotation.dart';

part 'invitation_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InvitationResponse {
  final String? id;
  final String? email;
  final String? role;
  final String? status;
  final DateTime? expiresAt;

  const InvitationResponse({
    this.id,
    this.email,
    this.role,
    this.status,
    this.expiresAt,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationResponseToJson(this);
}
