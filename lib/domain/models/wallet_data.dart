import 'package:json_annotation/json_annotation.dart';

part 'wallet_data.g.dart';

/// Accepts the float the websocket sends and the decimal string REST returns.
double _toDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double? _toNullableDouble(Object? value) {
  if (value == null) return null;
  return _toDouble(value);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WalletData {
  @JsonKey(defaultValue: 'WALLET_STATE')
  final String type;

  @JsonKey(fromJson: _toDouble)
  final double availableBalance;

  @JsonKey(fromJson: _toDouble)
  final double escrowBalance;

  @JsonKey(fromJson: _toDouble)
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

  /// Applies a partial frame (e.g. `WITHDRAWAL_COMPLETED`) on top of the last
  /// known state. Missing or null balances keep their previous value; they are
  /// never coerced to zero.
  WalletData merge(Map<String, dynamic> frame) {
    final available = _toNullableDouble(frame['available_balance']);
    final escrow = _toNullableDouble(frame['escrow_balance']);
    final total = _toNullableDouble(frame['total_balance']);
    final nextAvailable = available ?? availableBalance;
    final nextEscrow = escrow ?? escrowBalance;
    return WalletData(
      type: (frame['type'] as String?) ?? type,
      availableBalance: nextAvailable,
      escrowBalance: nextEscrow,
      totalBalance: total ?? (nextAvailable + nextEscrow),
      currency: (frame['currency'] as String?) ?? currency,
    );
  }

  String get currencySymbol {
    switch (currency.toUpperCase()) {
      case 'NGN':
        return '₦'; // ₦
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
