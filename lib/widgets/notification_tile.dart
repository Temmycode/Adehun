import 'package:adehun_mvp/core/utils/relative_time.dart';
import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:adehun_mvp/domain/models/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = notification.notificationType;
    final read = notification.isRead;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: read
              ? colors.surface
              : colors.primarySurface.withValues(alpha: 0.5),
          border: Border(bottom: BorderSide(color: colors.cardBorder)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _iconBgColor(type, colors),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _icon(type),
                color: _iconColor(type),
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
                          notification.title,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: read
                                ? FontWeight.w500
                                : FontWeight.w700,
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
                    notification.message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.createdAt.toRelativeTime(),
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

  IconData _icon(NotificationType type) => switch (type) {
    NotificationType.invitationReceived => Iconsax.sms_copy,
    NotificationType.agreementAccepted => Iconsax.tick_circle_copy,
    NotificationType.agreementDeclined => Iconsax.close_circle_copy,
    NotificationType.conditionAdded => Iconsax.add_circle_copy,
    NotificationType.conditionUpdated => Iconsax.refresh_circle_copy,
    NotificationType.agreementCompleted => Iconsax.verify_copy,
    NotificationType.general => Iconsax.notification_copy,
  };

  Color _iconColor(NotificationType type) => switch (type) {
    NotificationType.invitationReceived => AppColors.primary,
    NotificationType.agreementAccepted => AppColors.success,
    NotificationType.agreementDeclined => AppColors.error,
    NotificationType.conditionAdded => AppColors.info,
    NotificationType.conditionUpdated => AppColors.info,
    NotificationType.agreementCompleted => AppColors.success,
    NotificationType.general => AppColors.accent,
  };

  Color _iconBgColor(NotificationType type, AppColorScheme colors) =>
      switch (type) {
        NotificationType.invitationReceived => colors.primarySurface,
        NotificationType.agreementAccepted => colors.successLight,
        NotificationType.agreementDeclined => colors.errorLight,
        NotificationType.conditionAdded => colors.infoLight,
        NotificationType.conditionUpdated => colors.infoLight,
        NotificationType.agreementCompleted => colors.successLight,
        NotificationType.general => colors.warningLight,
      };
}
