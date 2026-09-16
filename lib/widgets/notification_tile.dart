import 'package:adehun_mvp/core/utils/relative_time.dart';
import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:adehun_mvp/domain/models/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// One notification row. `NotificationTileSkeleton` mirrors these metrics:
/// 16px padding, a 42px icon tile, 12px gap, three text lines.
class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = notification.notificationType;
    final read = notification.isRead;
    final (icon, fg, bg) = _look(type, colors);

    return Semantics(
      button: onTap != null,
      label: '${read ? '' : 'Unread. '}${notification.title}',
      child: Material(
        color: read ? colors.surface : colors.primarySurface.withValues(alpha: 0.45),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.cardBorder)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: fg, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
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
                                color: colors.textPrimary,
                                fontWeight: read ? FontWeight.w500 : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (!read)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: AppSpacing.sm),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.createdAt.toRelativeTime(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (IconData, Color, Color) _look(NotificationType type, AppColorScheme colors) =>
      switch (type) {
        NotificationType.invitationReceived => (
            Iconsax.sms_copy,
            AppColors.primary,
            colors.primarySurface,
          ),
        NotificationType.agreementAccepted => (
            Iconsax.tick_circle_copy,
            AppColors.success,
            colors.successLight,
          ),
        NotificationType.agreementDeclined ||
        NotificationType.agreementCancelled => (
            Iconsax.close_circle_copy,
            AppColors.error,
            colors.errorLight,
          ),
        NotificationType.conditionAdded => (
            Iconsax.add_circle_copy,
            AppColors.info,
            colors.infoLight,
          ),
        NotificationType.conditionUpdated => (
            Iconsax.refresh_circle_copy,
            AppColors.info,
            colors.infoLight,
          ),
        NotificationType.agreementCompleted => (
            Iconsax.verify_copy,
            AppColors.success,
            colors.successLight,
          ),
        NotificationType.escrowFunded => (
            Iconsax.wallet_check,
            AppColors.primary,
            colors.primarySurface,
          ),
        NotificationType.escrowReleased ||
        NotificationType.withdrawalCompleted => (
            Iconsax.money_send,
            AppColors.success,
            colors.successLight,
          ),
        NotificationType.escrowRefunded => (
            Iconsax.refresh_copy,
            AppColors.goldDark,
            colors.goldLight,
          ),
        NotificationType.walletCredited => (
            Iconsax.wallet_add,
            AppColors.success,
            colors.successLight,
          ),
        NotificationType.withdrawalFailed ||
        NotificationType.disputeRaised => (
            Iconsax.warning_2_copy,
            AppColors.error,
            colors.errorLight,
          ),
        NotificationType.disputeEvidenceAdded => (
            Iconsax.paperclip_copy,
            AppColors.info,
            colors.infoLight,
          ),
        NotificationType.disputeUnderReview => (
            Iconsax.timer_1_copy,
            AppColors.goldDark,
            colors.goldLight,
          ),
        NotificationType.disputeResolved => (
            Iconsax.tick_circle_copy,
            AppColors.success,
            colors.successLight,
          ),
        NotificationType.general => (
            Iconsax.notification_copy,
            AppColors.goldDark,
            colors.goldLight,
          ),
      };
}
