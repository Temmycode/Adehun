import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_buttons.dart';
import 'app_card.dart';

/// Three-step explainer shown on Home until the user has an agreement or
/// dismisses it.
class HowEscrowWorksCard extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback? onCreate;

  const HowEscrowWorksCard({super.key, required this.onDismiss, this.onCreate});

  static const _steps = [
    (
      Iconsax.document_text_copy,
      'Set the terms',
      'Say what is being paid for, how much, and what has to happen first.'
    ),
    (
      Iconsax.lock_copy,
      'Lock the money',
      'The payer funds escrow. The other side sees it is there but cannot touch it.'
    ),
    (
      Iconsax.tick_circle_copy,
      'Release when done',
      'Approve each condition as it is delivered. Money moves only when you say so.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      color: colors.primarySurface,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'How Adehun works',
                  style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                ),
              ),
              Semantics(
                button: true,
                label: 'Dismiss',
                child: InkWell(
                  onTap: onDismiss,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Icon(Iconsax.close_circle_copy, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < _steps.length; i++) ...[
            _Step(index: i + 1, icon: _steps[i].$1, title: _steps[i].$2, body: _steps[i].$3),
            if (i < _steps.length - 1) const SizedBox(height: AppSpacing.md),
          ],
          if (onCreate != null) ...[
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Create your first agreement',
              icon: Iconsax.add,
              onPressed: onCreate,
            ),
          ],
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String body;

  const _Step({
    required this.index,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index. $title',
                style: AppTextStyles.labelLarge.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
