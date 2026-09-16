import 'package:json_annotation/json_annotation.dart';

/// Why the dispute was raised.
///
/// [wire] is the value the API expects — `.name` is camelCase and would be
/// rejected with a 422. [label] is what the category chips display.
///
/// [unknown] is never sent; it exists so a category added server-side degrades
/// a single field instead of throwing and killing the whole list parse. Build
/// pickers from [selectable], not [values].
enum DisputeCategory {
  @JsonValue('quality_issues')
  qualityIssues('quality_issues', 'Quality Issues'),
  @JsonValue('missed_deadline')
  missedDeadline('missed_deadline', 'Missed Deadline'),
  @JsonValue('incomplete_work')
  incompleteWork('incomplete_work', 'Incomplete Work'),
  @JsonValue('non_responsive')
  nonResponsive('non_responsive', 'Non-responsive'),
  @JsonValue('other')
  other('other', 'Other'),
  unknown('unknown', 'Unknown');

  final String wire;
  final String label;

  const DisputeCategory(this.wire, this.label);

  static List<DisputeCategory> get selectable =>
      values.where((category) => category != unknown).toList();
}

/// Where the dispute is in the review process.
enum DisputeStatus {
  @JsonValue('open')
  open('open', 'Open'),
  @JsonValue('under_review')
  underReview('under_review', 'Under Review'),
  @JsonValue('resolved')
  resolved('resolved', 'Resolved'),
  unknown('unknown', 'Unknown');

  final String wire;
  final String label;

  const DisputeStatus(this.wire, this.label);

  /// Still being worked — blocks raising another dispute on the agreement.
  bool get isLive => this == open || this == underReview;
}

/// How a resolved dispute was decided.
///
/// Record-only — per the API, none of these move money. Resolving writes the
/// outcome and unfreezes the agreement; payout stays on the release flow.
enum DisputeResolutionOutcome {
  @JsonValue('favour_depositor')
  favourDepositor('favour_depositor', 'In favour of depositor'),
  @JsonValue('favour_beneficiary')
  favourBeneficiary('favour_beneficiary', 'In favour of beneficiary'),
  @JsonValue('split')
  split('split', 'Split'),
  @JsonValue('dismissed')
  dismissed('dismissed', 'Dismissed'),
  unknown('unknown', 'Unknown');

  final String wire;
  final String label;

  const DisputeResolutionOutcome(this.wire, this.label);
}
