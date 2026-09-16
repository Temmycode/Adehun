import 'package:adehun_mvp/controllers/auth_controller.dart';
import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_card.dart';
import 'avatar_initials.dart';
import 'money_text.dart';
import 'status_pill.dart';

/// List card for an agreement: who it is with, what it is for, how much, and
/// how far along the conditions are.
///
/// Layout (the skeleton in `skeletons.dart` mirrors these metrics):
///   [avatar 44] 12 [title / "with X · role"] 8 [status pill]
///   14
///   [amount]                        [n/m conditions  ▬▬▬]
class AgreementCard extends ConsumerWidget {
  final AgreementResponse agreement;
  final VoidCallback? onTap;

  const AgreementCard({super.key, required this.agreement, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final me = ref.watch(authControllerProvider).userData;
    final depositor = agreement.depositor;
    final beneficiary = agreement.beneficiary;

    final iAmDepositor = _isMe(depositor, me?.email, me?.id);
    final iAmBeneficiary = _isMe(beneficiary, me?.email, me?.id);
    final counterpart = iAmDepositor
        ? beneficiary
        : iAmBeneficiary
            ? depositor
            : beneficiary ?? depositor;
    final counterpartName = _displayName(counterpart);
    final roleLine = iAmDepositor
        ? 'You pay'
        : iAmBeneficiary
            ? 'Pays you'
            : null;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarInitials(
                name: counterpartName,
                imageUrl: counterpart?.profilePictureUrl,
                size: 44,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agreement.title ?? 'Untitled agreement',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      roleLine == null
                          ? 'with $counterpartName'
                          : '$counterpartName · $roleLine',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusPill.agreement(agreement.status, size: StatusPillSize.sm),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MoneyText.fromString(
                agreement.amount,
                style: AppTextStyles.amountMedium.copyWith(fontSize: 20),
                color: colors.textPrimary,
              ),
              const Spacer(),
              if (agreement.conditionCount > 0)
                _ConditionProgress(
                  met: agreement.conditionsMetCount,
                  total: agreement.conditionCount,
                )
              else
                Row(
                  children: [
                    Icon(
                      Iconsax.task_square_copy,
                      size: 14,
                      color: colors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'No conditions yet',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  static bool _isMe(Participant? p, String? email, String? id) {
    if (p == null) return false;
    if (id != null && p.id != null && p.id == id) return true;
    if (email != null && p.email != null) {
      return p.email!.toLowerCase() == email.toLowerCase();
    }
    return false;
  }

  static String _displayName(Participant? p) {
    final name = p?.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = p?.email?.trim();
    if (email != null && email.isNotEmpty) return email.split('@').first;
    return 'Invited party';
  }
}

class _ConditionProgress extends StatelessWidget {
  final int met;
  final int total;

  const _ConditionProgress({required this.met, required this.total});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final done = total > 0 && met >= total;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          done ? Iconsax.tick_circle : Iconsax.task_square_copy,
          size: 14,
          color: done ? AppColors.success : colors.textTertiary,
        ),
        const SizedBox(width: 6),
        Text(
          '$met/$total conditions',
          style: AppTextStyles.labelSmall.copyWith(
            color: done ? AppColors.success : colors.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 48,
          height: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: total > 0 ? met / total : 0,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                done ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
