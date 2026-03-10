import 'package:flutter/material.dart';
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
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            config.label,
            style: (compact ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
                .copyWith(color: config.color),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return _StatusConfig('Draft', AppColors.statusDraft, AppColors.statusDraftBg);
      case 'PENDING_ACCEPTANCE':
        return _StatusConfig('Pending', AppColors.statusPending, AppColors.statusPendingBg);
      case 'ACTIVE':
        return _StatusConfig('Active', AppColors.statusActive, AppColors.statusActiveBg);
      case 'CONDITIONS_IN_PROGRESS':
        return _StatusConfig('In Progress', AppColors.statusInProgress, AppColors.statusInProgressBg);
      case 'CONDITIONS_MET':
        return _StatusConfig('Conditions Met', AppColors.statusConditionsMet, AppColors.statusConditionsMetBg);
      case 'COMPLETED':
        return _StatusConfig('Completed', AppColors.statusCompleted, AppColors.statusCompletedBg);
      case 'DISPUTED':
        return _StatusConfig('Disputed', AppColors.statusDisputed, AppColors.statusDisputedBg);
      case 'CANCELLED':
        return _StatusConfig('Cancelled', AppColors.statusCancelled, AppColors.statusCancelledBg);
      case 'REFUNDED':
        return _StatusConfig('Refunded', AppColors.statusRefunded, AppColors.statusRefundedBg);
      // Condition statuses
      case 'MET':
        return _StatusConfig('Met', AppColors.statusCompleted, AppColors.statusCompletedBg);
      case 'IN_PROGRESS':
        return _StatusConfig('In Progress', AppColors.statusInProgress, AppColors.statusInProgressBg);
      case 'PENDING':
        return _StatusConfig('Pending', AppColors.statusPending, AppColors.statusPendingBg);
      // Asset statuses
      case 'APPROVED':
        return _StatusConfig('Approved', AppColors.statusCompleted, AppColors.statusCompletedBg);
      case 'REJECTED':
        return _StatusConfig('Rejected', AppColors.statusDisputed, AppColors.statusDisputedBg);
      default:
        return _StatusConfig(status, AppColors.statusDraft, AppColors.statusDraftBg);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final Color backgroundColor;

  _StatusConfig(this.label, this.color, this.backgroundColor);
}
