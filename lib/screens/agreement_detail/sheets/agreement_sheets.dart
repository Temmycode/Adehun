import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/utils/format_currency.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_color_scheme.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_tokens.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_buttons.dart';
import '../agreement_actions.dart';

/// Confirms agreeing. Resolves true when the user confirms.
Future<bool> showAgreeConfirmationSheet(
  BuildContext context, {
  required bool isDepositor,
  required double amount,
  required String otherPartyName,
}) async {
  final result = await showAppBottomSheet<bool>(
    context,
    builder: (sheetContext) => _ConfirmBody(
      icon: isDepositor ? Iconsax.wallet_check : Iconsax.people,
      iconColor: AppColors.primary,
      title: isDepositor ? 'Agree and fund escrow' : 'Agree to the terms',
      message: isDepositor
          ? 'You are about to move ${formatMoney(amount)} from your wallet into escrow. It stays there until every condition is approved, then goes to $otherPartyName. If your wallet is short, we will top it up first.'
          : 'By agreeing, both of you confirm the conditions are final and the escrow becomes active. $otherPartyName funds the escrow. Nothing is charged to you.',
      confirmLabel: isDepositor ? 'Agree & fund' : 'Agree',
      cancelLabel: 'Not yet',
    ),
  );
  return result ?? false;
}

/// Confirms cancelling. Resolves true when the user confirms.
Future<bool> showCancelConfirmationSheet(BuildContext context) async {
  final result = await showAppBottomSheet<bool>(
    context,
    builder: (sheetContext) => const _ConfirmBody(
      icon: Iconsax.close_circle,
      iconColor: AppColors.error,
      title: 'Cancel this agreement?',
      message:
          'This ends the agreement for both of you and cannot be undone. No money has moved, so nothing needs refunding.',
      confirmLabel: 'Yes, cancel it',
      cancelLabel: 'Keep it',
      danger: true,
    ),
  );
  return result ?? false;
}

/// Overflow menu. Resolves with the chosen action or null.
Future<AgreementAction?> showAgreementOptionsSheet(
  BuildContext context, {
  required List<AgreementAction> actions,
}) {
  return showAppBottomSheet<AgreementAction>(
    context,
    title: 'More options',
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final action in actions)
          _OptionTile(
            action: action,
            onTap: () => Navigator.of(sheetContext).pop(action),
          ),
      ],
    ),
  );
}

class _ConfirmBody extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool danger;

  const _ConfirmBody({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: danger ? colors.errorLight : colors.primarySurface,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: AppTextStyles.h2.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(
          label: confirmLabel,
          tone: danger ? ButtonTone.danger : ButtonTone.primary,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: AppSpacing.xs),
        TertiaryButton(
          label: cancelLabel,
          expand: true,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final AgreementAction action;
  final VoidCallback onTap;

  const _OptionTile({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, label, color) = switch (action) {
      AgreementAction.raiseDispute => (
          Iconsax.warning_2_copy,
          'Raise a dispute',
          AppColors.error,
        ),
      AgreementAction.cancel => (
          Iconsax.close_circle_copy,
          'Cancel agreement',
          AppColors.error,
        ),
      AgreementAction.agree => (
          Iconsax.tick_circle_copy,
          'Agree',
          colors.textPrimary,
        ),
      AgreementAction.fund => (
          Iconsax.wallet_add_copy,
          'Fund escrow',
          colors.textPrimary,
        ),
    };
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(color: color),
      ),
      onTap: onTap,
    );
  }
}
