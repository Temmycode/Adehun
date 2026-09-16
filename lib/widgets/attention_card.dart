import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../domain/models/attention_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// One "Needs your attention" card. Fixed width so a row of them scrolls
/// horizontally on Home. `AttentionCardSkeleton` mirrors these metrics.
class AttentionCard extends StatelessWidget {
  static const double width = 264;

  final AttentionItem item;
  final VoidCallback? onTap;

  const AttentionCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, tint, bg) = switch (item.kind) {
      AttentionKind.invitation => (
          Iconsax.user_add,
          AppColors.accentDark,
          colors.accentLight,
        ),
      AttentionKind.agree => (
          Iconsax.document_text,
          AppColors.accentDark,
          colors.accentLight,
        ),
      AttentionKind.fund => (
          Iconsax.wallet_add,
          AppColors.goldDark,
          colors.goldLight,
        ),
      AttentionKind.review => (
          Iconsax.task_square,
          AppColors.primary,
          colors.primarySurface,
        ),
      AttentionKind.dispute => (
          Iconsax.warning_2,
          AppColors.error,
          colors.errorLight,
        ),
    };

    return Semantics(
      button: true,
      label: '${item.title}, ${item.subtitle}',
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, size: 20, color: tint),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Iconsax.arrow_right_3_copy, size: 16, color: tint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
