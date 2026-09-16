import 'package:flutter/material.dart';

import '../core/utils/format_currency.dart';
import '../theme/app_text_styles.dart';

/// Formatted amount in tabular figures, with a hidden variant for balances.
class MoneyText extends StatelessWidget {
  final num amount;
  final String? currency;
  final TextStyle? style;
  final Color? color;
  final bool hidden;

  /// Optional leading sign, e.g. '+' or '-'.
  final String? sign;
  final TextAlign? textAlign;

  const MoneyText(
    this.amount, {
    super.key,
    this.currency,
    this.style,
    this.color,
    this.hidden = false,
    this.sign,
    this.textAlign,
  });

  /// For API payloads that carry amounts as decimal strings.
  MoneyText.fromString(
    String? amount, {
    super.key,
    this.currency,
    this.style,
    this.color,
    this.hidden = false,
    this.sign,
    this.textAlign,
  }) : amount = double.tryParse(amount ?? '') ?? 0;

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppTextStyles.amountMedium;
    final text = hidden
        ? '${currencySymbol(currency)}••••••'
        : '${sign ?? ''}${formatMoney(amount, currency: currency)}';
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: color == null ? base : base.copyWith(color: color),
    );
  }
}
