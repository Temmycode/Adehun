import 'package:flutter/services.dart';

/// Formats number input with thousands separators (commas).
/// e.g. 1000000 → 1,000,000
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Strip out everything except digits and decimal point
    final stripped = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Prevent multiple decimal points
    final parts = stripped.split('.');
    if (parts.length > 2) return oldValue;

    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Add commas to whole part
    final formatted = _addCommas(wholePart) + decimalPart;

    // Calculate new cursor position
    final newCursorOffset = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }

  String _addCommas(String number) {
    if (number.isEmpty) return '';
    final buffer = StringBuffer();
    final len = number.length;
    for (var i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(number[i]);
    }
    return buffer.toString();
  }
}
