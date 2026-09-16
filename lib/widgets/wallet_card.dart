import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'money_text.dart';
import 'skeletons.dart';

/// The wallet hero: available balance on a solid green card with the fund,
/// withdraw and history actions. Actions render only when their callback is
/// given, so Home can show two and Wallet three.
class WalletCard extends ConsumerWidget {
  final bool showActions;
  final VoidCallback? onFundWallet;
  final VoidCallback? onWithdraw;
  final VoidCallback? onHistory;
  final bool compact;
  final ValueNotifier<bool> balanceVisible;

  const WalletCard({
    super.key,
    this.showActions = true,
    this.onFundWallet,
    this.onWithdraw,
    this.onHistory,
    this.compact = false,
    required this.balanceVisible,
  });

  static const _cream = Color(0xFFFFFCF5);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletDataControllerProvider);
    final padding = compact ? AppSpacing.xl : AppSpacing.xxl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.floating(
          context,
          tint: AppColors.primary.withValues(alpha: 0.28),
        ),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: balanceVisible,
        builder: (context, visible, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Available balance',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: _cream.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: visible ? 'Hide balance' : 'Show balance',
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        balanceVisible.value = !visible;
                      },
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _cream.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          visible ? Iconsax.eye_copy : Iconsax.eye_slash_copy,
                          color: _cream,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
              wallet.when(
                data: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: MoneyText(
                        data.availableBalance,
                        currency: data.currency,
                        hidden: !visible,
                        color: _cream,
                        style: compact
                            ? AppTextStyles.amountLarge
                            : AppTextStyles.amountHero,
                      ),
                    ),
                    if (data.escrowBalance > 0) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.lock_copy,
                            size: 13,
                            color: _cream.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 6),
                          MoneyText(
                            data.escrowBalance,
                            currency: data.currency,
                            hidden: !visible,
                            style: AppTextStyles.labelMedium,
                            color: _cream.withValues(alpha: 0.85),
                          ),
                          Text(
                            ' held in escrow',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: _cream.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                loading: () => WalletBalanceSkeleton(compact: compact),
                error: (_, _) => Text(
                  'Balance unavailable',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _cream.withValues(alpha: 0.85),
                  ),
                ),
              ),
              if (showActions) ...[
                SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
                Row(
                  children: [
                    if (onFundWallet != null)
                      Expanded(
                        child: _Action(
                          icon: Iconsax.add,
                          label: 'Fund',
                          filled: true,
                          onTap: onFundWallet!,
                        ),
                      ),
                    if (onWithdraw != null) ...[
                      if (onFundWallet != null) const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _Action(
                          icon: Iconsax.arrow_up_2,
                          label: 'Withdraw',
                          onTap: onWithdraw!,
                        ),
                      ),
                    ],
                    if (onHistory != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _Action(
                          icon: Iconsax.receipt_2_copy,
                          label: 'History',
                          onTap: onHistory!,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    const cream = WalletCard._cream;
    final fg = filled ? AppColors.primaryDark : cream;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: filled ? cream : cream.withValues(alpha: 0.14),
        shape: StadiumBorder(
          side: filled
              ? BorderSide.none
              : BorderSide(color: cream.withValues(alpha: 0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.buttonMedium.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
