import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import 'status_badge.dart';

class AgreementCard extends StatelessWidget {
  final AgreementResponse agreement;
  final List<ConditionResponse> conditions;
  final VoidCallback? onTap;

  const AgreementCard({
    super.key,
    required this.agreement,
    required this.conditions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final amount = double.parse(agreement.amount ?? '0');
    final status = agreement.status ?? 'pending';
    final depositor = agreement.depositor;
    final beneficiary = agreement.beneficiary;
    // final conditions = agreement['conditions'] as List;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title + status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    agreement.title ?? '',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: status, compact: true),
              ],
            ),
            const SizedBox(height: 14),
            // Row 2: Amount + parties inline
            Row(
              children: [
                // Amount
                Text(
                  '\u20A6${_formatAmount(amount)}',
                  style: AppTextStyles.amountMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                // Parties - compact inline avatars
                _InlineParties(
                  depositorInitials: depositor?.initials ?? "",
                  beneficiaryInitials: beneficiary != null
                      ? beneficiary.initials
                      : '?',
                ),
              ],
            ),
            // Row 3: Conditions progress (only if conditions exist)
            if (conditions.isNotEmpty) ...[
              const SizedBox(height: 14),
              _ConditionBar(
                met: _metConditions(conditions),
                total: conditions.length,
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _metConditions(List<ConditionResponse> conditions) {
    return conditions.where((c) => c.status == 'MET').length;
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final decimal = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    return '${buffer.toString()}.$decimal';
  }
}

class _InlineParties extends StatelessWidget {
  final String depositorInitials;
  final String beneficiaryInitials;

  const _InlineParties({
    required this.depositorInitials,
    required this.beneficiaryInitials,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniAvatar(initials: depositorInitials),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Iconsax.arrow_right_3_copy,
            size: 12,
            color: colors.textTertiary,
          ),
        ),
        _MiniAvatar(initials: beneficiaryInitials),
      ],
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String initials;

  const _MiniAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CircleAvatar(
      radius: 14,
      backgroundColor: colors.primarySurface,
      child: Text(
        initials,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.primary,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ConditionBar extends StatelessWidget {
  final int met;
  final int total;

  const _ConditionBar({required this.met, required this.total});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(Iconsax.task_square_copy, size: 14, color: colors.textTertiary),
        const SizedBox(width: 6),
        Text(
          '$met/$total conditions',
          style: AppTextStyles.labelSmall.copyWith(
            color: colors.textTertiary,
            fontSize: 11,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 48,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: total > 0 ? met / total : 0,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                met == total ? AppColors.statusCompleted : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
