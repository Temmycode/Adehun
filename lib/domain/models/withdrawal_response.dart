import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_response.g.dart';

/// `WithdrawalResponse` from `POST /wallet/withdraw` and
/// `GET /wallet/withdrawals/{reference}`. Money fields are decimal strings.
@JsonSerializable(fieldRename: FieldRename.snake)
class WithdrawalResponse {
  final String reference;
  final String amount;
  @JsonKey(defaultValue: 'NGN')
  final String currency;

  /// pending | success | failed | refunded
  final String status;
  final String? bankAccountId;
  final String? accountNumber;
  final String? bankName;
  final String? availableBalance;
  final String? failureReason;
  final DateTime? createdAt;

  const WithdrawalResponse({
    required this.reference,
    required this.amount,
    required this.currency,
    required this.status,
    this.bankAccountId,
    this.accountNumber,
    this.bankName,
    this.availableBalance,
    this.failureReason,
    this.createdAt,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isSuccess => status.toLowerCase() == 'success';
  bool get isFailed => const {'failed', 'refunded'}.contains(status.toLowerCase());

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalResponseToJson(this);
}
