import 'package:json_annotation/json_annotation.dart';

part 'agreement_response.g.dart';

@JsonSerializable(fieldRename: .snake)
class AgreementResponse {
  final String? id;
  final String? title;
  final String? description;
  final String? amount;
  final String? status;
  final DateTime? createdAt;

  const AgreementResponse({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.status,
    this.createdAt,
  });

  factory AgreementResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementResponseToJson(this);
}
