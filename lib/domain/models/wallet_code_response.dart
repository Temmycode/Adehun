import 'package:json_annotation/json_annotation.dart';

part 'wallet_code_response.g.dart';

/// `FundInitResponse` from `POST /wallet/fund`.
@JsonSerializable(fieldRename: FieldRename.snake)
class WalletCodeResponse {
  final String accessCode;

  /// Our own payment reference. Recorded server-side before Paystack is called,
  /// so this is what a support query should quote, not the SDK's reference.
  @JsonKey(defaultValue: '')
  final String reference;
  final String? authorizationUrl;

  /// Decimal string, as everywhere in the REST API.
  @JsonKey(defaultValue: '0')
  final String amount;

  const WalletCodeResponse({
    required this.accessCode,
    required this.reference,
    this.authorizationUrl,
    required this.amount,
  });

  factory WalletCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletCodeResponseToJson(this);
}
