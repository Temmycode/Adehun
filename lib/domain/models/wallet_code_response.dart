import 'package:json_annotation/json_annotation.dart';

part 'wallet_code_response.g.dart';

@JsonSerializable(fieldRename: .snake)
class WalletCodeResponse {
  final String accessCode;

  const WalletCodeResponse({required this.accessCode});

  factory WalletCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletCodeResponseToJson(this);
}
