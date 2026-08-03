import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// The icon tile + title + subtitle + optional action used for every empty and
/// error state in the app.
///
/// Set [compact] when the placeholder sits inline under a header rather than
/// filling a screen — it shrinks the tile and padding so it doesn't overflow.
class ListStatePlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Color? iconColor;
  final Color? iconBackground;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  const ListStatePlaceholder({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.iconColor,
    this.iconBackground,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  /// Error flavour: warning icon on [AppColorScheme.errorLight] with a
  /// "Try again" action.
  ///
  /// Parameters are named [heading]/[detail] rather than title/message because
  /// `title = title` in an initializer list is ambiguous.
  const ListStatePlaceholder.error({
    super.key,
    required String detail,
    String heading = 'Something went wrong',
    String retryLabel = 'Try again',
    VoidCallback? onRetry,
    this.compact = false,
  }) : icon = Iconsax.warning_2_copy,
       title = heading,
       message = detail,
       iconColor = AppColors.error,
       iconBackground = null,
       actionLabel = retryLabel,
       onAction = onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tile = compact ? 72.0 : 100.0;
    final isError = iconColor == AppColors.error;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 24 : 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: tile,
              height: tile,
              decoration: BoxDecoration(
                color:
                    iconBackground ??
                    (isError ? colors.errorLight : colors.primarySurface),
                borderRadius: BorderRadius.circular(compact ? 20 : 28),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: compact ? 30 : 44,
              ),
            ),
            SizedBox(height: compact ? 16 : 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
            if (onAction != null) ...[
              SizedBox(height: compact ? 12 : 20),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel ?? 'Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
