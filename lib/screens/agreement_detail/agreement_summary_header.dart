import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/domain/models/participant.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_color_scheme.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';
import '../../utils/agreement_status.dart';
import '../../widgets/app_card.dart';
import '../../widgets/avatar_initials.dart';
import '../../widgets/money_text.dart';
import '../../widgets/status_pill.dart';

/// Status, title, description, then the amount card with the counterpart.
class AgreementSummaryHeader extends StatelessWidget {
  final AgreementResponse agreement;
  final Participant? counterpart;
  final String counterpartName;
  final bool isDepositor;
  final bool isParty;

  const AgreementSummaryHeader({
    super.key,
    required this.agreement,
    required this.counterpart,
    required this.counterpartName,
    required this.isDepositor,
    required this.isParty,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = AgreementStatusHelper.normalize(agreement.status);
    final description = agreement.description?.trim();
    final funded = agreement.isFunded;
    final settled = status == AgreementStatusHelper.completed ||
        status == AgreementStatusHelper.refunded ||
        status == AgreementStatusHelper.cancelled;

    final (fundIcon, fundLabel, fundColor) = settled
        ? (Iconsax.tick_circle_copy, 'Settled', colors.textSecondary)
        : funded
            ? (Iconsax.lock, 'Held in escrow', AppColors.success)
            : (Iconsax.unlock_copy, 'Not funded yet', AppColors.goldDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusPill.agreement(status),
        const SizedBox(height: AppSpacing.md),
        Text(
          agreement.title ?? 'Untitled agreement',
          style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          color: AppColors.primary,
          bordered: false,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escrow amount',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: MoneyText.fromString(
                  agreement.amount,
                  style: AppTextStyles.amountLarge,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  AvatarInitials(
                    name: counterpartName,
                    imageUrl: counterpart?.profilePictureUrl,
                    size: 36,
                    showBorder: true,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      !isParty
                          ? 'Between the two parties'
                          : isDepositor
                              ? 'You pay $counterpartName'
                              : '$counterpartName pays you',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          fundIcon,
                          size: 12,
                          color: fundColor == AppColors.success
                              ? const Color(0xFF8FD3B8)
                              : fundColor == AppColors.goldDark
                                  ? const Color(0xFFF0C878)
                                  : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          fundLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
