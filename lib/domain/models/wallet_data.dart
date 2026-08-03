import 'package:json_annotation/json_annotation.dart';

part 'wallet_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WalletData {
  final String type;

  @JsonKey(defaultValue: 0.0)
  final double availableBalance;

  @JsonKey(defaultValue: 0.0)
  final double escrowBalance;

  @JsonKey(defaultValue: 0.0)
  final double totalBalance;

  @JsonKey(defaultValue: 'NGN')
  final String currency;

  const WalletData({
    required this.type,
    required this.availableBalance,
    required this.escrowBalance,
    required this.totalBalance,
    required this.currency,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);

  String get currencySymbol {
    switch (currency.toUpperCase()) {
      case 'NGN':
        return '\u20A6'; // ₦
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'EUR':
        return '€';
      case 'JPY':
        return '¥';
      default:
        return currency; // Fallback to the code if unknown
    }
  }
}
