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
  @JsonKey(defaultValue: false)
  final bool currentUserAccepted;

  /// Whether the depositor's money has been moved into escrow.
  ///
  /// The beneficiary cannot be paid until this is true — release runs against
  /// the escrow balance, not the depositor's wallet.
  @JsonKey(defaultValue: false)
  final bool isFunded;

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
    this.currentUserAccepted = false,
    this.isFunded = false,
  });

  AgreementResponse copyWith({
    String? id,
    String? title,
    String? description,
    String? amount,
    String? status,
    Participant? depositor,
    Participant? beneficiary,
    DateTime? createdAt,
    int? conditionCount,
    int? conditionsMetCount,
    bool? currentUserAccepted,
    bool? isFunded,
  }) {
    return AgreementResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      depositor: depositor ?? this.depositor,
      beneficiary: beneficiary ?? this.beneficiary,
      createdAt: createdAt ?? this.createdAt,
      conditionCount: conditionCount ?? this.conditionCount,
      conditionsMetCount: conditionsMetCount ?? this.conditionsMetCount,
      currentUserAccepted: currentUserAccepted ?? this.currentUserAccepted,
      isFunded: isFunded ?? this.isFunded,
    );
  }

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
