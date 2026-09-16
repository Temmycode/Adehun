import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_color_scheme.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';
import '../../utils/condition_status.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/list_state_placeholder.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/status_pill.dart';

/// Conditions as a vertical checklist with a progress bar.
///
/// `ConditionTimelineSkeleton` in `skeletons.dart` mirrors the row metrics:
/// a 28px marker, 12px gap, then a card with 12px padding.
class ConditionsTimeline extends StatelessWidget {
  final List<ConditionResponse> conditions;
  final bool loading;
  final bool canAdd;
  final bool showProgress;
  final String? currentUserEmail;
  final VoidCallback? onAdd;
  final ValueChanged<ConditionResponse> onTap;

  const ConditionsTimeline({
    super.key,
    required this.conditions,
    required this.loading,
    required this.canAdd,
    required this.showProgress,
    required this.currentUserEmail,
    required this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final met = conditions.where((c) => ConditionStatusHelper.isMet(c.status)).length;
    final total = conditions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Conditions',
                style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
              ),
            ),
            if (total > 0)
              Text(
                '$met of $total approved',
                style: AppTextStyles.labelMedium.copyWith(
                  color: met == total ? AppColors.success : colors.textSecondary,
                ),
              ),
          ],
        ),
        if (showProgress && total > 0) ...[
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: met / total,
              minHeight: 6,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                met == total ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (loading && conditions.isEmpty)
          const ConditionListSkeleton()
        else if (conditions.isEmpty)
          AppCard(
            padding: EdgeInsets.zero,
            child: ListStatePlaceholder(
              compact: true,
              icon: Iconsax.task_square_copy,
              title: canAdd ? 'No conditions yet' : 'No conditions',
              message: canAdd
                  ? 'Add what has to happen before the money is released.'
                  : 'Nothing was added to this agreement.',
            ),
          )
        else
          for (var i = 0; i < conditions.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == conditions.length - 1 ? 0 : AppSpacing.md,
              ),
              child: _TimelineRow(
                index: i,
                isLast: i == conditions.length - 1,
                condition: conditions[i],
                currentUserEmail: currentUserEmail,
                onTap: () => onTap(conditions[i]),
              ),
            ),
        if (canAdd && onAdd != null) ...[
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Add condition',
            icon: Iconsax.add,
            onPressed: onAdd,
          ),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final int index;
  final bool isLast;
  final ConditionResponse condition;
  final String? currentUserEmail;
  final VoidCallback onTap;

  const _TimelineRow({
    required this.index,
    required this.isLast,
    required this.condition,
    required this.currentUserEmail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = ConditionStatusHelper.normalize(condition.status);
    final met = status == ConditionStatusHelper.approved;
    final rejected = status == ConditionStatusHelper.rejected;
    final submitted = status == ConditionStatusHelper.submitted;

    final markerColor = met
        ? AppColors.success
        : rejected
            ? AppColors.error
            : submitted
                ? AppColors.gold
                : colors.cardBorder;

    final who = condition.requiredFromParticipant?.user;
    final whoIsMe = who?.email != null &&
        currentUserEmail != null &&
        who!.email!.toLowerCase() == currentUserEmail!.toLowerCase();
    final whoName = whoIsMe ? 'you' : (who?.name?.trim().isNotEmpty == true ? who!.name!.trim() : 'the other party');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: met ? AppColors.success : colors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: markerColor, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: met
                      ? const Icon(Iconsax.tick_circle, size: 16, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: colors.cardBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppCard(
              onTap: onTap,
              padding: const EdgeInsets.all(AppSpacing.md),
              radius: AppRadius.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condition.title ?? 'Untitled condition',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                      decoration: met ? TextDecoration.lineThrough : null,
                      decorationColor: colors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          met ? 'Approved' : 'Needs $whoName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      StatusPill.condition(condition.status),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
