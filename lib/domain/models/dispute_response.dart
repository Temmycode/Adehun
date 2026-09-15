import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/domain/models/assets_response.dart';
import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dispute_response.g.dart';

/// `explicitToJson` matters here: this model is cached to SharedPreferences,
/// and without it the nested [UserData] / [AssetsResponse] would serialise as
/// instance handles instead of maps.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DisputeResponse {
  final String? id;
  final String? agreementId;
  final String? agreementTitle;

  /// Decimal string, matching `AgreementResponse.amount`. Parse at the render
  /// site rather than here.
  final String? agreementAmount;

  @JsonKey(unknownEnumValue: DisputeCategory.unknown)
  final DisputeCategory? category;
  final String? description;
  @JsonKey(unknownEnumValue: DisputeStatus.unknown)
  final DisputeStatus? status;
  final UserData? raisedBy;
  final UserData? againstUser;
  @JsonKey(unknownEnumValue: DisputeResolutionOutcome.unknown)
  final DisputeResolutionOutcome? resolutionOutcome;
  final String? resolutionNotes;
  final UserData? resolvedBy;
  final DateTime? resolvedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(defaultValue: <AssetsResponse>[])
  final List<AssetsResponse>? evidence;

  const DisputeResponse({
    this.id,
    this.agreementId,
    this.agreementTitle,
    this.agreementAmount,
    this.category,
    this.description,
    this.status,
    this.raisedBy,
    this.againstUser,
    this.resolutionOutcome,
    this.resolutionNotes,
    this.resolvedBy,
    this.resolvedAt,
    this.createdAt,
    this.updatedAt,
    this.evidence,
  });

  /// Still open or under review — the agreement stays frozen and a second
  /// dispute can't be raised.
  bool get isLive => status?.isLive ?? false;

  factory DisputeResponse.fromJson(Map<String, dynamic> json) =>
      _$DisputeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DisputeResponseToJson(this);
}
