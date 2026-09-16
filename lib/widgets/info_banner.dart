import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

enum BannerTone { info, success, warning, error, neutral }

/// Tinted inline message with an icon, for "what happens next" copy.
class InfoBanner extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final BannerTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  const InfoBanner({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.tone = BannerTone.info,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (bg, fg, defaultIcon) = switch (tone) {
      BannerTone.info => (
          colors.infoLight,
          AppColors.info,
          Iconsax.info_circle_copy,
        ),
      BannerTone.success => (
          colors.successLight,
          AppColors.success,
          Iconsax.tick_circle_copy,
        ),
      BannerTone.warning => (
          colors.goldLight,
          AppColors.goldDark,
          Iconsax.warning_2_copy,
        ),
      BannerTone.error => (
          colors.errorLight,
          AppColors.error,
          Iconsax.warning_2_copy,
        ),
      BannerTone.neutral => (
          colors.surfaceVariant,
          colors.textSecondary,
          Iconsax.info_circle_copy,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, size: 20, color: fg),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: fg,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
