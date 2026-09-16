// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisputeResponse _$DisputeResponseFromJson(Map<String, dynamic> json) =>
    DisputeResponse(
      id: json['id'] as String?,
      agreementId: json['agreement_id'] as String?,
      agreementTitle: json['agreement_title'] as String?,
      agreementAmount: json['agreement_amount'] as String?,
      category: $enumDecodeNullable(
        _$DisputeCategoryEnumMap,
        json['category'],
        unknownValue: DisputeCategory.unknown,
      ),
      description: json['description'] as String?,
      status: $enumDecodeNullable(
        _$DisputeStatusEnumMap,
        json['status'],
        unknownValue: DisputeStatus.unknown,
      ),
      raisedBy: json['raised_by'] == null
          ? null
          : UserData.fromJson(json['raised_by'] as Map<String, dynamic>),
      againstUser: json['against_user'] == null
          ? null
          : UserData.fromJson(json['against_user'] as Map<String, dynamic>),
      resolutionOutcome: $enumDecodeNullable(
        _$DisputeResolutionOutcomeEnumMap,
        json['resolution_outcome'],
        unknownValue: DisputeResolutionOutcome.unknown,
      ),
      resolutionNotes: json['resolution_notes'] as String?,
      resolvedBy: json['resolved_by'] == null
          ? null
          : UserData.fromJson(json['resolved_by'] as Map<String, dynamic>),
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      evidence:
          (json['evidence'] as List<dynamic>?)
              ?.map((e) => AssetsResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DisputeResponseToJson(DisputeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agreement_id': instance.agreementId,
      'agreement_title': instance.agreementTitle,
      'agreement_amount': instance.agreementAmount,
      'category': _$DisputeCategoryEnumMap[instance.category],
      'description': instance.description,
      'status': _$DisputeStatusEnumMap[instance.status],
      'raised_by': instance.raisedBy?.toJson(),
      'against_user': instance.againstUser?.toJson(),
      'resolution_outcome':
          _$DisputeResolutionOutcomeEnumMap[instance.resolutionOutcome],
      'resolution_notes': instance.resolutionNotes,
      'resolved_by': instance.resolvedBy?.toJson(),
      'resolved_at': instance.resolvedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'evidence': instance.evidence?.map((e) => e.toJson()).toList(),
    };

const _$DisputeCategoryEnumMap = {
  DisputeCategory.qualityIssues: 'quality_issues',
  DisputeCategory.missedDeadline: 'missed_deadline',
  DisputeCategory.incompleteWork: 'incomplete_work',
  DisputeCategory.nonResponsive: 'non_responsive',
  DisputeCategory.other: 'other',
  DisputeCategory.unknown: 'unknown',
};

const _$DisputeStatusEnumMap = {
  DisputeStatus.open: 'open',
  DisputeStatus.underReview: 'under_review',
  DisputeStatus.resolved: 'resolved',
  DisputeStatus.unknown: 'unknown',
};

const _$DisputeResolutionOutcomeEnumMap = {
  DisputeResolutionOutcome.favourDepositor: 'favour_depositor',
  DisputeResolutionOutcome.favourBeneficiary: 'favour_beneficiary',
  DisputeResolutionOutcome.split: 'split',
  DisputeResolutionOutcome.dismissed: 'dismissed',
  DisputeResolutionOutcome.unknown: 'unknown',
};
