import 'package:adehun_mvp/core/utils/relative_time.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../theme/app_color_scheme.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_pill.dart';

/// Renders nothing until there is something to show. Most agreements never
/// have a dispute, and a skeleton would flash on every visit.
class DisputesSection extends StatelessWidget {
  final List<DisputeResponse> disputes;
  final String? currentUserEmail;

  const DisputesSection({
    super.key,
    required this.disputes,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (disputes.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Disputes',
          style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < disputes.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == disputes.length - 1 ? 0 : AppSpacing.md,
            ),
            child: _DisputeCard(
              dispute: disputes[i],
              currentUserEmail: currentUserEmail,
            ),
          ),
      ],
    );
  }
}

class _DisputeCard extends StatelessWidget {
  final DisputeResponse dispute;
  final String? currentUserEmail;

  const _DisputeCard({required this.dispute, this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final raisedBy = dispute.raisedBy;
    final isMine =
        currentUserEmail != null && raisedBy?.email == currentUserEmail;
    final evidenceCount = dispute.evidence?.length ?? 0;
    final description = dispute.description?.trim();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusPill.dispute(dispute.status, size: StatusPillSize.sm),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  dispute.category?.label ?? '',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Raised by ${isMine ? 'you' : raisedBy?.name ?? 'the other party'}'
                  '${dispute.createdAt != null ? ' · ${dispute.createdAt!.toRelativeTime()}' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ),
              if (evidenceCount > 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Iconsax.paperclip_copy,
                  size: 14,
                  color: colors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$evidenceCount file${evidenceCount != 1 ? 's' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          if (dispute.resolutionOutcome != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outcome: ${dispute.resolutionOutcome!.label}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  if (dispute.resolutionNotes != null &&
                      dispute.resolutionNotes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      dispute.resolutionNotes!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
