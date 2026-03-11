import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: compact ? 11 : 13,
            color: config.color,
          ),
          SizedBox(width: compact ? 4 : 5),
          Text(
            config.label,
            style: (compact
                    ? AppTextStyles.labelSmall
                    : AppTextStyles.labelMedium)
                .copyWith(color: config.color),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return _StatusConfig('Draft', AppColors.statusDraft,
            AppColors.statusDraftBg, Iconsax.edit_2_copy);
      case 'PENDING_ACCEPTANCE':
        return _StatusConfig('Pending', AppColors.statusPending,
            AppColors.statusPendingBg, Iconsax.timer_1_copy);
      case 'ACTIVE':
        return _StatusConfig('Active', AppColors.statusActive,
            AppColors.statusActiveBg, Iconsax.flash_1);
      case 'CONDITIONS_IN_PROGRESS':
        return _StatusConfig('In Progress', AppColors.statusInProgress,
            AppColors.statusInProgressBg, Iconsax.refresh_circle_copy);
      case 'CONDITIONS_MET':
        return _StatusConfig('Conditions Met', AppColors.statusConditionsMet,
            AppColors.statusConditionsMetBg, Iconsax.tick_square_copy);
      case 'COMPLETED':
        return _StatusConfig('Completed', AppColors.statusCompleted,
            AppColors.statusCompletedBg, Iconsax.tick_circle);
      case 'DISPUTED':
        return _StatusConfig('Disputed', AppColors.statusDisputed,
            AppColors.statusDisputedBg, Iconsax.warning_2_copy);
      case 'CANCELLED':
        return _StatusConfig('Cancelled', AppColors.statusCancelled,
            AppColors.statusCancelledBg, Iconsax.close_circle_copy);
      case 'REFUNDED':
        return _StatusConfig('Refunded', AppColors.statusRefunded,
            AppColors.statusRefundedBg, Iconsax.rotate_left_copy);
      // Condition statuses
      case 'MET':
        return _StatusConfig('Met', AppColors.statusCompleted,
            AppColors.statusCompletedBg, Iconsax.tick_circle);
      case 'IN_PROGRESS':
        return _StatusConfig('In Progress', AppColors.statusInProgress,
            AppColors.statusInProgressBg, Iconsax.refresh_circle_copy);
      case 'PENDING':
        return _StatusConfig('Pending', AppColors.statusPending,
            AppColors.statusPendingBg, Iconsax.timer_1_copy);
      // Asset statuses
      case 'APPROVED':
        return _StatusConfig('Approved', AppColors.statusCompleted,
            AppColors.statusCompletedBg, Iconsax.tick_circle);
      case 'REJECTED':
        return _StatusConfig('Rejected', AppColors.statusDisputed,
            AppColors.statusDisputedBg, Iconsax.warning_2_copy);
      default:
        return _StatusConfig(status, AppColors.statusDraft,
            AppColors.statusDraftBg, Iconsax.edit_2_copy);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  _StatusConfig(this.label, this.color, this.backgroundColor, this.icon);
}
