import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:adehun_mvp/domain/models/participant_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ConditionResponse {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final ParticipantResponse? createdByParticipant;
  final ParticipantResponse? requiredFromParticipant;
  final InvitationResponse? invitation;
  final DateTime? approvedAt;
  final String? rejectedReason;
  final DateTime? createdAt;
  final String? agreementId;

  const ConditionResponse({
    this.id,
    this.title,
    this.description,
    this.status,
    this.createdByParticipant,
    this.requiredFromParticipant,
    this.invitation,
    this.approvedAt,
    this.rejectedReason,
    this.createdAt,
    this.agreementId,
  });

  factory ConditionResponse.fromJson(Map<String, dynamic> json) =>
      _$ConditionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionResponseToJson(this);
}
