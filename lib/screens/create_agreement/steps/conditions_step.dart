import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_color_scheme.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_tokens.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_chip.dart';
import '../../../widgets/info_banner.dart';
import '../draft_condition.dart';

class ConditionsStep extends StatelessWidget {
  final List<DraftCondition> conditions;
  final String otherPartyName;
  final bool showError;
  final VoidCallback onAdd;
  final ValueChanged<String> onAddFromTemplate;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;

  const ConditionsStep({
    super.key,
    required this.conditions,
    required this.otherPartyName,
    required this.showError,
    required this.onAdd,
    required this.onAddFromTemplate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final usedTitles = conditions.map((c) => c.title.toLowerCase()).toSet();
    final templates = conditionTemplates
        .where((t) => !usedTitles.contains(t.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What has to happen?',
          style: AppTextStyles.displayMedium.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The money is released only after every condition is approved. Either side can add more later.',
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (conditions.isEmpty) ...[
          const InfoBanner(
            tone: BannerTone.info,
            message:
                'Start with something concrete, like "Deliver the files" or "Confirm receipt". Keep each one small enough to tick off.',
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        for (var i = 0; i < conditions.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _DraftCard(
              index: i,
              condition: conditions[i],
              otherPartyName: otherPartyName,
              onEdit: () => onEdit(i),
              onDelete: () => onDelete(i),
            ),
          ),
        if (showError) ...[
          Text(
            'Add at least one condition to continue.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        SecondaryButton(
          label: conditions.isEmpty ? 'Add a condition' : 'Add another',
          icon: Iconsax.add,
          onPressed: onAdd,
        ),
        if (templates.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Quick add',
            style: AppTextStyles.labelMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final template in templates)
                AppChip(
                  label: template,
                  icon: Iconsax.add,
                  onTap: () => onAddFromTemplate(template),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DraftCard extends StatelessWidget {
  final int index;
  final DraftCondition condition;
  final String otherPartyName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DraftCard({
    required this.index,
    required this.condition,
    required this.otherPartyName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      onTap: onEdit,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.primarySurface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condition.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (condition.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    condition.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  condition.isForMe ? 'You do this' : '$otherPartyName does this',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Remove condition',
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(
                  Iconsax.close_circle_copy,
                  size: 20,
                  color: colors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
