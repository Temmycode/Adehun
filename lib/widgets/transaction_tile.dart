import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../core/utils/format_currency.dart';
import '../core/utils/relative_time.dart';
import '../domain/models/transaction.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import 'status_pill.dart';

typedef _TypeVisuals = ({
  IconData icon,
  Color foreground,
  Color background,
  String label,
});

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visuals = _visualsFor(transaction.type, colors);

    final isCredit = transaction.direction == TransactionDirection.credit;
    final isPending = transaction.status == TransactionStatus.pending;
    final isReversed = transaction.status == TransactionStatus.reversed;

    // The API sends an unsigned decimal string; `direction` carries the sign.
    final amount = double.tryParse(transaction.amount) ?? 0;

    final amountColor = isReversed
        ? colors.textTertiary
        : isPending
        ? colors.textSecondary
        : isCredit
        ? AppColors.success
        : colors.textPrimary;

    final description = transaction.description?.trim();
    final title = (description == null || description.isEmpty)
        ? visuals.label
        : description;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: visuals.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(visuals.icon, color: visuals.foreground, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        transaction.createdAt.toRelativeTime(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      if (isPending || isReversed) ...[
                        const SizedBox(width: 6),
                        StatusPill.transaction(transaction.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${isCredit ? '+' : '-'}'
              '${formatMoney(amount, currency: transaction.currency)}',
              style: AppTextStyles.labelLarge.copyWith(
                color: amountColor,
                decoration: isReversed ? TextDecoration.lineThrough : null,
                decorationColor: colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _TypeVisuals _visualsFor(TransactionType type, AppColorScheme colors) =>
      switch (type) {
        TransactionType.unknown => (
          icon: Iconsax.receipt_2_copy,
          foreground: AppColors.primary,
          background: colors.surfaceVariant,
          label: 'Transaction',
        ),
        TransactionType.deposit => (
          icon: Iconsax.wallet_add_copy,
          foreground: AppColors.success,
          background: colors.successLight,
          label: 'Wallet funding',
        ),
        TransactionType.escrowLock => (
          icon: Iconsax.lock_copy,
          foreground: AppColors.primary,
          background: colors.primarySurface,
          label: 'Escrow lock',
        ),
        TransactionType.escrowReleaseOut => (
          icon: Iconsax.export_1_copy,
          foreground: AppColors.primary,
          background: colors.primarySurface,
          label: 'Escrow released',
        ),
        TransactionType.escrowReleaseIn => (
          icon: Iconsax.import_1_copy,
          foreground: AppColors.success,
          background: colors.successLight,
          label: 'Escrow received',
        ),
        TransactionType.escrowRefund => (
          icon: Iconsax.rotate_left_copy,
          foreground: AppColors.warning,
          background: colors.warningLight,
          label: 'Escrow refund',
        ),
        TransactionType.withdrawal => (
          icon: Iconsax.wallet_minus_copy,
          foreground: AppColors.info,
          background: colors.infoLight,
          label: 'Withdrawal',
        ),
        TransactionType.withdrawalReversal => (
          icon: Iconsax.undo_copy,
          foreground: AppColors.warning,
          background: colors.warningLight,
          label: 'Withdrawal reversed',
        ),
        TransactionType.adjustmentCredit => (
          icon: Iconsax.add_circle_copy,
          foreground: AppColors.success,
          background: colors.successLight,
          label: 'Credit adjustment',
        ),
        TransactionType.adjustmentDebit => (
          // sic — the typo is in the icon package.
          icon: Iconsax.minus_cirlce_copy,
          foreground: AppColors.error,
          background: colors.errorLight,
          label: 'Debit adjustment',
        ),
      };
}

