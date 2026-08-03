import 'package:intl/intl.dart';

/// Pattern form rather than `NumberFormat.currency` so no locale data has to be
/// initialised, and the output matches the hand-rolled formatters it replaces.
final NumberFormat _decimal = NumberFormat('#,##0.00');

const Map<String, String> _currencySymbols = {
  'NGN': '₦',
  'USD': '\$',
  'GBP': '£',
  'EUR': '€',
};

/// Falls back to the naira sign — every amount in the app is NGN today, and the
/// backend omits the currency on some payloads.
String currencySymbol([String? code]) =>
    _currencySymbols[code?.toUpperCase()] ?? '₦';

/// `1234.5` -> `1,234.50`
String formatAmount(num amount) => _decimal.format(amount);

/// `1234.5` -> `₦1,234.50`
String formatMoney(num amount, {String? currency}) =>
    '${currencySymbol(currency)}${formatAmount(amount)}';

/// For API models that carry amounts as decimal strings.
String formatMoneyString(String? amount, {String? currency}) =>
    formatMoney(double.tryParse(amount ?? '') ?? 0, currency: currency);
