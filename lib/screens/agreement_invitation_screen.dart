import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../constants/mock_data.dart';

class AgreementInvitationScreen extends StatelessWidget {
  final String agreementId;

  const AgreementInvitationScreen({super.key, required this.agreementId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final agreement = MockData.agreements.firstWhere(
      (a) => a['id'] == agreementId,
      orElse: () => MockData.agreements[2],
    );

    final depositor = agreement['depositor'] as Map<String, dynamic>;
    final amount = agreement['amount'] as double;
    final conditions = agreement['conditions'] as List;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Agreement Invitation', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Invitation header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.primarySurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      depositor['initials'] as String,
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${depositor['name']} invited you',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'to an escrow agreement',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Agreement details
            Text('Agreement Summary', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow('Title', agreement['title'] as String),
                  const SizedBox(height: 12),
                  _DetailRow(
                      'Description', agreement['description'] as String),
                  const SizedBox(height: 12),
                  _DetailRow('Amount',
                      '\u20A6${_formatAmount(amount)}'),
                  const SizedBox(height: 12),
                  _DetailRow('Your Role', 'Beneficiary'),
                  const SizedBox(height: 12),
                  _DetailRow(
                      'Conditions', '${conditions.length} conditions'),
                ],
              ),
            ),

            // Conditions preview
            if (conditions.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('Conditions', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              ...conditions.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Iconsax.tick_square_copy,
                            color: colors.textTertiary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            c['title'] as String,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],

            const Spacer(),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      context.push('/agreement/$agreementId');
                    },
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final decimal = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    return '${buffer.toString()}.$decimal';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.labelLarge,
          ),
        ),
      ],
    );
  }
}
