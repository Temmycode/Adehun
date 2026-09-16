import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

enum ToastKind { success, error, info }

/// Floating toast. Replaces the previous one while it is still showing so
/// bursts of errors do not queue up.
void showAppToast(
  BuildContext context,
  String message, {
  ToastKind kind = ToastKind.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 3),
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  final (icon, tint) = switch (kind) {
    ToastKind.success => (Iconsax.tick_circle, const Color(0xFF5FD39F)),
    ToastKind.error => (Iconsax.warning_2, const Color(0xFFFF9A8C)),
    ToastKind.info => (Iconsax.info_circle, AppColors.gold),
  };

  if (kind == ToastKind.success) HapticFeedback.mediumImpact();
  if (kind == ToastKind.error) HapticFeedback.heavyImpact();

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        content: Row(
          children: [
            Icon(icon, size: 20, color: tint),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: tint,
                onPressed: onAction ?? () {},
              ),
      ),
    );
}
