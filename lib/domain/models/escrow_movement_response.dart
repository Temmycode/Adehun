import 'package:json_annotation/json_annotation.dart';

part 'escrow_movement_response.g.dart';

/// Result of moving an agreement's amount between wallet and escrow.
///
/// Amounts and balances stay [String] — the API sends decimal strings, matching
/// `AgreementResponse.amount`, and nothing renders these numerically.
@JsonSerializable(fieldRename: FieldRename.snake)
class EscrowMovementResponse {
  final String agreementId;
  final String amount;
  final String reference;
  final String availableBalance;
  final String escrowBalance;

  /// True when the ledger already held this movement, so the call was a no-op.
  /// The money moved on an earlier attempt — this is success, not a failure.
  @JsonKey(defaultValue: false)
  final bool replayed;

  const EscrowMovementResponse({
    required this.agreementId,
    required this.amount,
    required this.reference,
    required this.availableBalance,
    required this.escrowBalance,
    this.replayed = false,
  });

  factory EscrowMovementResponse.fromJson(Map<String, dynamic> json) =>
      _$EscrowMovementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EscrowMovementResponseToJson(this);
}
