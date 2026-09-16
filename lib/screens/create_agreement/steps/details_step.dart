import 'package:flutter/material.dart';

import '../../../theme/app_color_scheme.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_tokens.dart';
import '../../../widgets/amount_field.dart';
import '../../../widgets/labeled_field.dart';

/// Escrow minimum in naira.
const double kMinimumEscrowAmount = 100000;

class DetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController amountController;

  const DetailsStep({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's the deal?",
            style: AppTextStyles.displayMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'A clear title and description help the other party know exactly what they are agreeing to.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          LabeledField(
            label: 'Title',
            hint: 'e.g. Website redesign for Ada Bakery',
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Add a title';
              if (v.length < 3) return 'Make the title a little longer';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          LabeledField(
            label: 'Description',
            hint: 'What is being delivered, by when, and anything else that matters',
            controller: descriptionController,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.newline,
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Add a description';
              if (v.length < 10) return 'Add a little more detail';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AmountField(
            controller: amountController,
            label: 'Escrow amount',
            helper: 'Held safely until both of you are happy. Minimum ₦100,000.',
            quickAmounts: const [100000, 250000, 500000, 1000000],
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Add an amount';
              final parsed = AmountField.parse(v);
              if (parsed == null) return 'Enter a valid amount';
              if (parsed < kMinimumEscrowAmount) {
                return 'The minimum is ₦100,000';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
