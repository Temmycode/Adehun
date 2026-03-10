import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'status_badge.dart';

class AgreementCard extends StatelessWidget {
  final Map<String, dynamic> agreement;
  final VoidCallback? onTap;

  const AgreementCard({
    super.key,
    required this.agreement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amount = agreement['amount'] as double;
    final status = agreement['status'] as String;
    final depositor = agreement['depositor'] as Map<String, dynamic>;
    final beneficiary = agreement['beneficiary'] as Map<String, dynamic>;
    final conditions = agreement['conditions'] as List;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    agreement['title'] as String,
                    style: AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: status, compact: true),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\u20A6${_formatAmount(amount)}',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _PartyAvatar(
                    initials: depositor['initials'] as String,
                    label: 'Depositor',
                    name: depositor['name'] as String,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Iconsax.arrow_right_2,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  _PartyAvatar(
                    initials: (beneficiary['initials'] as String).isNotEmpty
                        ? beneficiary['initials'] as String
                        : '?',
                    label: 'Beneficiary',
                    name: (beneficiary['name'] as String).isNotEmpty
                        ? beneficiary['name'] as String
                        : 'Not assigned',
                  ),
                ],
              ),
            ),
            if (conditions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Iconsax.task_square_copy,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_metConditions(conditions)}/${conditions.length} conditions met',
                    style: AppTextStyles.bodySmall,
                  ),
                  const Spacer(),
                  _ConditionProgress(
                    met: _metConditions(conditions),
                    total: conditions.length,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _metConditions(List conditions) {
    return conditions.where((c) => c['status'] == 'MET').length;
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

class _PartyAvatar extends StatelessWidget {
  final String initials;
  final String label;
  final String name;

  const _PartyAvatar({
    required this.initials,
    required this.label,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primarySurface,
            child: Text(
              initials,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall,
                ),
                Text(
                  name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionProgress extends StatelessWidget {
  final int met;
  final int total;

  const _ConditionProgress({
    required this.met,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: total > 0 ? met / total : 0,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(
            met == total ? AppColors.statusCompleted : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
