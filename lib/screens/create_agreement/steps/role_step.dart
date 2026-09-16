import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_color_scheme.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_tokens.dart';
import '../../../widgets/labeled_field.dart';

final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

class RoleStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String role;
  final ValueChanged<String> onRoleChanged;
  final TextEditingController inviteController;

  const RoleStep({
    super.key,
    required this.formKey,
    required this.role,
    required this.onRoleChanged,
    required this.inviteController,
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
            "Who's who?",
            style: AppTextStyles.displayMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'The payer funds escrow. The other side gets paid once the conditions are approved.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  icon: Iconsax.money_send,
                  title: "I'm paying",
                  subtitle: 'I fund the escrow and approve the work',
                  selected: role == 'depositor',
                  onTap: () => onRoleChanged('depositor'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _RoleCard(
                  icon: Iconsax.money_recive,
                  title: "I'm getting paid",
                  subtitle: 'I deliver the work and get released the funds',
                  selected: role == 'beneficiary',
                  onTap: () => onRoleChanged('beneficiary'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),
          LabeledField(
            label: role == 'depositor'
                ? 'Who are you paying?'
                : 'Who is paying you?',
            hint: 'Their email address or phone number',
            helper:
                "We'll send them an invitation. If they don't have Adehun yet, they can join from the link.",
            controller: inviteController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            prefix: const Icon(Iconsax.user_add_copy),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Enter an email or phone number';
              if (emailRegex.hasMatch(v) || phoneRegex.hasMatch(v)) return null;
              return 'Enter a valid email or phone number';
            },
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: '$title. $subtitle',
      child: Material(
        color: selected ? colors.primarySurface : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: selected ? AppColors.primary : colors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: selected ? Colors.white : colors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    AnimatedOpacity(
                      duration: AppMotion.fast,
                      opacity: selected ? 1 : 0,
                      child: const Icon(
                        Iconsax.tick_circle,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: selected ? AppColors.primary : colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
