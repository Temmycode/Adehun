import 'package:adehun_mvp/domain/models/notification_type.dart';
import 'package:adehun_mvp/utils/agreement_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationModel {
  static const String agreementStatusKey = 'status';

  final String id;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationType get notificationType => NotificationType.fromRaw(type);

  Map<String, dynamic> get _metadata => metadata ?? const {};

  String? get agreementId => _metadata['agreement_id'] as String?;
  String? get conditionId => _metadata['condition_id'] as String?;
  String? get invitedByName => _metadata['invited_by_name'] as String?;
  String? get agreementDecisionStatus =>
      (_metadata[agreementStatusKey] as String?)?.trim().toUpperCase();

  bool get isAgreementAccepted =>
      AgreementStatusHelper.normalize(agreementDecisionStatus) ==
      AgreementStatusHelper.active;

  bool get isAgreementDeclined =>
      AgreementStatusHelper.normalize(agreementDecisionStatus) ==
      AgreementStatusHelper.cancelled;

  NotificationModel markAgreementDecisionStatus({required bool accepted}) {
    final status = accepted
        ? AgreementStatusHelper.active
        : AgreementStatusHelper.cancelled;
    final nextMetadata = {..._metadata, agreementStatusKey: status};

    return copyWith(metadata: nextMetadata);
  }

  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? createdAt,
  }) {
    final mergedMetadata = metadata ?? this.metadata;
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      metadata: mergedMetadata == null
          ? null
          : Map<String, dynamic>.from(mergedMetadata),
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
