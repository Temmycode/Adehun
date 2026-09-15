import 'package:json_annotation/json_annotation.dart';

part 'invite_lookup.g.dart';

/// Minimal, unauthenticated view of an invitation from `GET /invitations/{token}`.
@JsonSerializable(fieldRename: FieldRename.snake)
class InviteLookup {
  final String agreementId;
  @JsonKey(defaultValue: '')
  final String agreementTitle;
  @JsonKey(defaultValue: 'Someone')
  final String inviterName;
  @JsonKey(defaultValue: '')
  final String role;
  @JsonKey(defaultValue: 'pending')
  final String status;
  final DateTime? expiresAt;
  @JsonKey(defaultValue: '')
  final String emailHint;

  const InviteLookup({
    required this.agreementId,
    required this.agreementTitle,
    required this.inviterName,
    required this.role,
    required this.status,
    this.expiresAt,
    required this.emailHint,
  });

  factory InviteLookup.fromJson(Map<String, dynamic> json) =>
      _$InviteLookupFromJson(json);

  Map<String, dynamic> toJson() => _$InviteLookupToJson(this);
}
