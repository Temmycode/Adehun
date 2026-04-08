import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ParticipantResponse {
  final String? id;
  final String? agreementId;
  final String? role;
  final String? status;
  final UserData? user;

  const ParticipantResponse({
    this.id,
    this.agreementId,
    this.role,
    this.status,
    this.user,
  });

  factory ParticipantResponse.fromJson(Map<String, dynamic> json) =>
      _$ParticipantResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantResponseToJson(this);
}
