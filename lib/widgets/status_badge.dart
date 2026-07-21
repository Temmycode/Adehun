import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../utils/agreement_status.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusBadge({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final config = _getStatusConfig(status, colors);
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
          Icon(config.icon, size: compact ? 11 : 13, color: config.color),
          SizedBox(width: compact ? 4 : 5),
          Text(
            config.label,
            style:
                (compact ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
                    .copyWith(color: config.color),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status, AppColorScheme colors) {
    final normalized = AgreementStatusHelper.normalize(status);

    switch (normalized) {
      case AgreementStatusHelper.draft:
        return _StatusConfig(
          'Draft',
          AppColors.statusDraft,
          colors.statusDraftBg,
          Iconsax.edit_2_copy,
        );
      case AgreementStatusHelper.pending:
        return _StatusConfig(
          'Pending',
          AppColors.statusPending,
          colors.statusPendingBg,
          Iconsax.timer_1_copy,
        );
      case AgreementStatusHelper.active:
        return _StatusConfig(
          'Active',
          AppColors.statusActive,
          colors.statusActiveBg,
          Iconsax.flash_1,
        );
      case AgreementStatusHelper.completed:
        return _StatusConfig(
          'Completed',
          AppColors.statusCompleted,
          colors.statusCompletedBg,
          Iconsax.tick_circle,
        );
      case AgreementStatusHelper.disputed:
        return _StatusConfig(
          'Disputed',
          AppColors.statusDisputed,
          colors.statusDisputedBg,
          Iconsax.warning_2_copy,
        );
      case AgreementStatusHelper.cancelled:
        return _StatusConfig(
          'Cancelled',
          AppColors.statusCancelled,
          colors.statusCancelledBg,
          Iconsax.close_circle_copy,
        );
      case AgreementStatusHelper.refunded:
        return _StatusConfig(
          'Refunded',
          AppColors.statusRefunded,
          colors.statusRefundedBg,
          Iconsax.rotate_left_copy,
        );
      default:
        return _StatusConfig(
          AgreementStatusHelper.displayLabel(status),
          AppColors.statusDraft,
          colors.statusDraftBg,
          Iconsax.edit_2_copy,
        );
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
