import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// Pill chip for filters, quick amounts and suggestion templates.
class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int? count;
  final IconData? icon;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.count,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = selected ? Colors.white : colors.textPrimary;
    final bg = selected ? AppColors.primary : colors.surface;
    final border = selected ? AppColors.primary : colors.cardBorder;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: bg,
        shape: StadiumBorder(side: BorderSide(color: border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(color: fg),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.2)
                          : colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      '$count',
                      style: AppTextStyles.numberSmall.copyWith(
                        color: selected ? Colors.white : colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
