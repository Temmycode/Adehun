import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = notification['type'] as String;
    final title = notification['title'] as String;
    final message = notification['message'] as String;
    final timestamp = notification['timestamp'] as String;
    final read = notification['read'] as bool;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: read ? colors.surface : colors.primarySurface.withValues(alpha: 0.5),
          border: Border(
            bottom: BorderSide(color: colors.cardBorder),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _getIconBgColor(type, colors),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(type),
                color: _getIconColor(type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: read ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timestamp,
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'INVITATION':
        return Iconsax.sms_copy;
      case 'CONDITION_UPDATE':
        return Iconsax.refresh_circle_copy;
      case 'APPROVAL':
        return Iconsax.tick_circle_copy;
      case 'PAYMENT':
        return Iconsax.wallet_3_copy;
      case 'DISPUTE':
        return Iconsax.warning_2_copy;
      case 'REMINDER':
        return Iconsax.notification_copy;
      default:
        return Iconsax.notification_copy;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'INVITATION':
        return AppColors.primary;
      case 'CONDITION_UPDATE':
        return AppColors.info;
      case 'APPROVAL':
        return AppColors.success;
      case 'PAYMENT':
        return AppColors.success;
      case 'DISPUTE':
        return AppColors.error;
      case 'REMINDER':
        return AppColors.accent;
      default:
        return AppColors.statusDraft;
    }
  }

  Color _getIconBgColor(String type, AppColorScheme colors) {
    switch (type) {
      case 'INVITATION':
        return colors.primarySurface;
      case 'CONDITION_UPDATE':
        return colors.infoLight;
      case 'APPROVAL':
        return colors.successLight;
      case 'PAYMENT':
        return colors.successLight;
      case 'DISPUTE':
        return colors.errorLight;
      case 'REMINDER':
        return colors.warningLight;
      default:
        return colors.surfaceVariant;
    }
  }
}
