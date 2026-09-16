import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/utils/format_currency.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../utils/currency_input_formatter.dart';
import 'app_chip.dart';

/// Large naira entry with thousands separators and optional quick amounts.
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? helper;
  final List<int> quickAmounts;
  final FormFieldValidator<String>? validator;
  final ValueChanged<double?>? onChanged;
  final bool autofocus;
  final bool enabled;
  final FocusNode? focusNode;

  const AmountField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.helper,
    this.quickAmounts = const [],
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.focusNode,
  });

  /// `"1,250,000.5"` -> `1250000.5`, or null when not a number.
  static double? parse(String text) =>
      double.tryParse(text.trim().replaceAll(',', ''));

  void _setAmount(int amount) {
    controller.text = formatAmount(amount).replaceAll('.00', '');
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
    onChanged?.call(amount.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          validator: validator,
          onChanged: (value) => onChanged?.call(parse(value)),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            CurrencyInputFormatter(),
          ],
          style: AppTextStyles.amountLarge.copyWith(
            color: colors.textPrimary,
            fontSize: 32,
          ),
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: AppTextStyles.amountLarge.copyWith(
              color: colors.textTertiary,
              fontSize: 32,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.sm,
              ),
              child: Text(
                currencySymbol(),
                style: AppTextStyles.amountLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: 28,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            helper!,
            style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
          ),
        ],
        if (quickAmounts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final amount in quickAmounts)
                AppChip(
                  label: '${currencySymbol()}${_short(amount)}',
                  onTap: enabled ? () => _setAmount(amount) : null,
                ),
            ],
          ),
        ],
      ],
    );
  }

  static String _short(int amount) {
    if (amount % 1000000 == 0) return '${amount ~/ 1000000}m';
    if (amount % 1000 == 0) return '${amount ~/ 1000}k';
    return formatAmount(amount).replaceAll('.00', '');
  }
}
