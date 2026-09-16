import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// Label above, helper below, themed [TextFormField] in between.
class LabeledField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helper;
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final AutovalidateMode? autovalidateMode;
  final Iterable<String>? autofillHints;

  const LabeledField({
    super.key,
    required this.label,
    this.hint,
    this.helper,
    this.controller,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textInputAction,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode,
    this.autofillHints,
  });

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
          initialValue: initialValue,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          autofocus: autofocus,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          textInputAction: textInputAction,
          focusNode: focusNode,
          textCapitalization: textCapitalization,
          autovalidateMode: autovalidateMode,
          autofillHints: autofillHints,
          style: AppTextStyles.bodyLarge.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
            counterText: '',
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            helper!,
            style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
          ),
        ],
      ],
    );
  }
}
