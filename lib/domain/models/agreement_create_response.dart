import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agreement_create_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AgreementCreateResponse {
  final String? id;
  final String? title;
  final String? description;
  final String? amount;
  final String? status;
  @JsonKey(fromJson: _participantFromJson, toJson: _participantToJson)
  final Participant? depositor;
  @JsonKey(fromJson: _participantFromJson, toJson: _participantToJson)
  final Participant? beneficiary;
  final DateTime? createdAt;
  final List<ConditionResponse>? conditions;

  const AgreementCreateResponse({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.status,
    this.depositor,
    this.beneficiary,
    this.createdAt,
    this.conditions,
  });

  factory AgreementCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreementCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementCreateResponseToJson(this);

  AgreementResponse toAgreementResponse() => AgreementResponse(
    id: id,
    title: title,
    description: description,
    amount: amount,
    status: status,
    depositor: depositor,
    beneficiary: beneficiary,
    createdAt: createdAt,
  );

  static Participant? _participantFromJson(Map<String, dynamic>? json) =>
      json == null ? null : Participant.fromJson(json);

  static Map<String, dynamic>? _participantToJson(Participant? participant) =>
      participant?.toJson();
}
