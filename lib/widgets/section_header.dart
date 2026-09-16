import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// Section title with an optional trailing action ("See all").
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.trailing,
    this.padding = AppInsets.screen,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                minimumSize: const Size(0, kMinTapTarget),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
