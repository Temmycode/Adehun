import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';

/// "Step 2 of 4 · Parties" with a segmented progress bar underneath.
class StepIndicator extends StatelessWidget {
  final int current;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.current,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final index = current.clamp(0, labels.length - 1);

    return Semantics(
      label: 'Step ${index + 1} of ${labels.length}, ${labels[index]}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step ${index + 1} of ${labels.length}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              Text(
                '  ·  ',
                style: AppTextStyles.labelMedium.copyWith(
                  color: colors.textTertiary,
                ),
              ),
              Text(
                labels[index],
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var i = 0; i < labels.length; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: AppMotion.normal,
                    curve: AppMotion.curve,
                    height: 5,
                    decoration: BoxDecoration(
                      color: i <= index ? AppColors.primary : colors.cardBorder,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (i < labels.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
