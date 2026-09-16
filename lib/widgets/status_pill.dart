import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constants/dispute_enums.dart';
import '../domain/models/transaction.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../utils/agreement_status.dart';

enum StatusPillSize { sm, md }

typedef _PillLook = ({String label, Color fg, Color bg, IconData icon});

/// The one status pill. Use the named factories so agreement, dispute and
/// transaction states share the same shape and colour language.
class StatusPill extends StatelessWidget {
  final String label;
  final Color? foreground;
  final Color? background;
  final IconData? icon;
  final StatusPillSize size;
  final _PillLook Function(AppColorScheme colors)? _resolver;

  const StatusPill({
    super.key,
    required this.label,
    required Color this.foreground,
    required Color this.background,
    this.icon,
    this.size = StatusPillSize.md,
  }) : _resolver = null;

  const StatusPill._resolved(
    this._resolver, {
    super.key,
    this.size = StatusPillSize.md,
  })  : label = '',
        foreground = null,
        background = null,
        icon = null;

  /// Agreement status, normalised through [AgreementStatusHelper].
  factory StatusPill.agreement(
    String? status, {
    Key? key,
    StatusPillSize size = StatusPillSize.md,
  }) {
    return StatusPill._resolved(
      (colors) => _agreementLook(status, colors),
      key: key,
      size: size,
    );
  }

  factory StatusPill.dispute(
    DisputeStatus? status, {
    Key? key,
    StatusPillSize size = StatusPillSize.md,
  }) {
    return StatusPill._resolved(
      (colors) => _disputeLook(status, colors),
      key: key,
      size: size,
    );
  }

  factory StatusPill.transaction(
    TransactionStatus status, {
    Key? key,
    StatusPillSize size = StatusPillSize.sm,
  }) {
    return StatusPill._resolved(
      (colors) => _transactionLook(status, colors),
      key: key,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final look = _resolver?.call(colors) ??
        (label: label, fg: foreground!, bg: background!, icon: icon ?? Iconsax.info_circle_copy);
    final small = size == StatusPillSize.sm;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpacing.sm : AppSpacing.md,
        vertical: small ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: look.bg,
        borderRadius: AppRadius.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_resolver != null || icon != null) ...[
            Icon(look.icon, size: small ? 11 : 13, color: look.fg),
            SizedBox(width: small ? 4 : 5),
          ],
          Text(
            look.label,
            style: (small ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
                .copyWith(color: look.fg),
          ),
        ],
      ),
    );
  }

  static _PillLook _agreementLook(String? status, AppColorScheme colors) {
    return switch (AgreementStatusHelper.normalize(status)) {
      AgreementStatusHelper.draft => (
          label: 'Draft',
          fg: AppColors.statusDraft,
          bg: colors.statusDraftBg,
          icon: Iconsax.edit_2_copy,
        ),
      AgreementStatusHelper.pending => (
          label: 'Pending',
          fg: AppColors.statusPending,
          bg: colors.statusPendingBg,
          icon: Iconsax.timer_1_copy,
        ),
      AgreementStatusHelper.active => (
          label: 'Active',
          fg: AppColors.statusActive,
          bg: colors.statusActiveBg,
          icon: Iconsax.flash_1,
        ),
      AgreementStatusHelper.completed => (
          label: 'Completed',
          fg: AppColors.statusCompleted,
          bg: colors.statusCompletedBg,
          icon: Iconsax.tick_circle,
        ),
      AgreementStatusHelper.disputed => (
          label: 'Disputed',
          fg: AppColors.statusDisputed,
          bg: colors.statusDisputedBg,
          icon: Iconsax.warning_2_copy,
        ),
      AgreementStatusHelper.cancelled => (
          label: 'Cancelled',
          fg: AppColors.statusCancelled,
          bg: colors.statusCancelledBg,
          icon: Iconsax.close_circle_copy,
        ),
      AgreementStatusHelper.refunded => (
          label: 'Refunded',
          fg: AppColors.statusRefunded,
          bg: colors.statusRefundedBg,
          icon: Iconsax.rotate_left_copy,
        ),
      _ => (
          label: AgreementStatusHelper.displayLabel(status),
          fg: AppColors.statusDraft,
          bg: colors.statusDraftBg,
          icon: Iconsax.edit_2_copy,
        ),
    };
  }

  static _PillLook _disputeLook(DisputeStatus? status, AppColorScheme colors) {
    return switch (status) {
      DisputeStatus.open => (
          label: DisputeStatus.open.label,
          fg: AppColors.error,
          bg: colors.errorLight,
          icon: Iconsax.warning_2_copy,
        ),
      DisputeStatus.underReview => (
          label: DisputeStatus.underReview.label,
          fg: AppColors.goldDark,
          bg: colors.goldLight,
          icon: Iconsax.timer_1_copy,
        ),
      DisputeStatus.resolved => (
          label: DisputeStatus.resolved.label,
          fg: AppColors.success,
          bg: colors.successLight,
          icon: Iconsax.tick_circle,
        ),
      _ => (
          label: DisputeStatus.unknown.label,
          fg: colors.textSecondary,
          bg: colors.surfaceVariant,
          icon: Iconsax.info_circle_copy,
        ),
    };
  }

  static _PillLook _transactionLook(
    TransactionStatus status,
    AppColorScheme colors,
  ) {
    return switch (status) {
      TransactionStatus.pending => (
          label: 'Pending',
          fg: AppColors.goldDark,
          bg: colors.goldLight,
          icon: Iconsax.timer_1_copy,
        ),
      TransactionStatus.reversed => (
          label: 'Reversed',
          fg: colors.textSecondary,
          bg: colors.surfaceVariant,
          icon: Iconsax.rotate_left_copy,
        ),
      TransactionStatus.completed => (
          label: 'Completed',
          fg: AppColors.success,
          bg: colors.successLight,
          icon: Iconsax.tick_circle_copy,
        ),
      TransactionStatus.unknown => (
          label: 'Unknown',
          fg: colors.textSecondary,
          bg: colors.surfaceVariant,
          icon: Iconsax.info_circle_copy,
        ),
    };
  }
}
