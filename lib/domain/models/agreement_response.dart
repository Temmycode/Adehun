import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agreement_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AgreementResponse {
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
  @JsonKey(defaultValue: 0)
  final int conditionCount;
  @JsonKey(defaultValue: 0)
  final int conditionsMetCount;

  const AgreementResponse({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.status,
    this.depositor,
    this.beneficiary,
    this.createdAt,
    this.conditionCount = 0,
    this.conditionsMetCount = 0,
  });

  factory AgreementResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementResponseToJson(this);

  factory AgreementResponse.fromCreateParams(
    CreateAgreementParams params,
    String tempId,
  ) {
    return AgreementResponse(
      id: tempId,
      title: params.title,
      description: params.description,
      amount: params.amount.toString(),
      status: "pending",
    );
  }

  static Participant? _participantFromJson(Map<String, dynamic>? json) =>
      json == null ? null : Participant.fromJson(json);

  static Map<String, dynamic>? _participantToJson(Participant? participant) =>
      participant?.toJson();
}
