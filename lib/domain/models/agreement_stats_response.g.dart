// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementStatsResponse _$AgreementStatsResponseFromJson(
  Map<String, dynamic> json,
) => AgreementStatsResponse(
  activeAgreements: (json['active_agreements'] as num).toInt(),
  completedAgreements: (json['completed_agreements'] as num).toInt(),
  totalAgreements: (json['total_agreements'] as num).toInt(),
);

Map<String, dynamic> _$AgreementStatsResponseToJson(
  AgreementStatsResponse instance,
) => <String, dynamic>{
  'active_agreements': instance.activeAgreements,
  'completed_agreements': instance.completedAgreements,
  'total_agreements': instance.totalAgreements,
};
