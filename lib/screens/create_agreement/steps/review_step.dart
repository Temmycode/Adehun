import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_color_scheme.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_tokens.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/info_banner.dart';
import '../../../widgets/money_text.dart';
import '../draft_condition.dart';

class ReviewStep extends StatelessWidget {
  final String title;
  final String description;
  final double amount;
  final String role;
  final String invite;
  final List<DraftCondition> conditions;
  final ValueChanged<int> onEditStep;

  const ReviewStep({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.role,
    required this.invite,
    required this.conditions,
    required this.onEditStep,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDepositor = role == 'depositor';
    final other = invite.contains('@') ? invite.split('@').first : invite;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Look good?',
          style: AppTextStyles.displayMedium.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This is what $other will see. You can still edit anything before sending.',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _Section(
          title: 'Details',
          onEdit: () => onEditStep(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Iconsax.lock_copy, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  MoneyText(
                    amount,
                    style: AppTextStyles.amountMedium,
                    color: AppColors.primary,
                  ),
                  Text(
                    '  in escrow',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Section(
          title: 'Parties',
          onEdit: () => onEditStep(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PartyLine(
                icon: Iconsax.money_send,
                label: 'Pays',
                value: isDepositor ? 'You' : invite,
              ),
              const SizedBox(height: AppSpacing.sm),
              _PartyLine(
                icon: Iconsax.money_recive,
                label: 'Gets paid',
                value: isDepositor ? invite : 'You',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Section(
          title: 'Conditions (${conditions.length})',
          onEdit: () => onEditStep(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < conditions.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == conditions.length - 1 ? 0 : AppSpacing.sm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}.',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          '${conditions[i].title} · ${conditions[i].isForMe ? 'you' : other}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        InfoBanner(
          tone: BannerTone.neutral,
          icon: Iconsax.send_2,
          message: isDepositor
              ? "We'll invite $other to accept. Nothing leaves your wallet until you both agree."
              : "We'll invite $other to accept and fund the escrow. You'll be notified when the money is locked in.",
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final Widget child;

  const _Section({required this.title, required this.onEdit, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _PartyLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PartyLine({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$label  ',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}
