import 'package:json_annotation/json_annotation.dart';

part 'agreement_stats_response.g.dart';

@JsonSerializable(fieldRename: .snake)
class AgreementStatsResponse {
  final int activeAgreements;
  final int completedAgreements;
  final int totalAgreements;

  AgreementStatsResponse({
    required this.activeAgreements,
    required this.completedAgreements,
    required this.totalAgreements,
  });

  const AgreementStatsResponse.empty()
    : activeAgreements = 0,
      completedAgreements = 0,
      totalAgreements = 0;

  factory AgreementStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$AgreementStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementStatsResponseToJson(this);
}
