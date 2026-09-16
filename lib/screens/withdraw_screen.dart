import 'package:adehun_mvp/controllers/bank_account_controller.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/controllers/withdraw_controller.dart';
import 'package:adehun_mvp/core/utils/format_currency.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:adehun_mvp/domain/states/withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/amount_field.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/info_banner.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/money_text.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccountId;
  double? _amount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(withdrawControllerProvider.notifier).reset();
      ref.read(bankAccountControllerProvider.notifier).loadAccounts();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? get _available => ref
      .read(walletDataControllerProvider)
      .maybeWhen(data: (d) => d.availableBalance, orElse: () => null);

  Future<void> _confirmAndSubmit(BankAccount account) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = AmountField.parse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final confirmed = await showAppBottomSheet<bool>(
      context,
      builder: (sheetContext) => _ConfirmWithdrawal(
        amount: amount,
        account: account,
      ),
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.mediumImpact();
    await ref
        .read(withdrawControllerProvider.notifier)
        .submit(amount: amount.toStringAsFixed(2), bankAccountId: account.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final withdraw = ref.watch(withdrawControllerProvider);
    final accounts = ref.watch(bankAccountControllerProvider);
    final available = ref.watch(walletDataControllerProvider).maybeWhen(
          data: (d) => d.availableBalance,
          orElse: () => null,
        );

    ref.listen(withdrawControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null &&
          error != prev?.errorMessage &&
          next.stage != WithdrawStage.failed) {
        showAppToast(context, error, kind: ToastKind.error);
        ref.read(withdrawControllerProvider.notifier).clearError();
      }
    });

    final selected =
        accounts.accounts.where((a) => a.id == _selectedAccountId).firstOrNull ??
            accounts.defaultAccount;

    final showForm = switch (withdraw.stage) {
      WithdrawStage.pending ||
      WithdrawStage.completed ||
      WithdrawStage.failed =>
        false,
      _ => !withdraw.disabled,
    };

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Withdraw'),
      bottomNavigationBar: showForm
          ? BottomActionBar(
              primary: PrimaryButton(
                label: (_amount ?? 0) > 0
                    ? 'Withdraw ${formatMoney(_amount!)}'
                    : 'Withdraw',
                loading: withdraw.isBusy,
                onPressed: selected == null || withdraw.isBusy
                    ? null
                    : () => _confirmAndSubmit(selected),
              ),
            )
          : null,
      body: AnimatedSwitcher(
        duration: AppMotion.normal,
        switchInCurve: AppMotion.curve,
        child: switch (withdraw.stage) {
          WithdrawStage.pending ||
          WithdrawStage.completed ||
          WithdrawStage.failed =>
            _StatusView(key: const ValueKey('status'), state: withdraw),
          _ => withdraw.disabled
              ? const _DisabledView(key: ValueKey('disabled'))
              : Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    key: const ValueKey('form'),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.sm,
                      AppSpacing.gutter,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AmountField(
                          controller: _amountController,
                          label: 'How much?',
                          autofocus: true,
                          onChanged: (v) => setState(() => _amount = v),
                          validator: (value) {
                            final parsed = AmountField.parse(value ?? '');
                            if (parsed == null || parsed <= 0) {
                              return 'Enter an amount';
                            }
                            final max = _available;
                            if (max != null && parsed > max + 0.01) {
                              return 'That is more than your available balance';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    'Available  ',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  if (available == null)
                                    Text(
                                      '…',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    )
                                  else
                                    MoneyText(
                                      available,
                                      style: AppTextStyles.labelMedium,
                                      color: colors.textPrimary,
                                    ),
                                ],
                              ),
                            ),
                            if (available != null && available > 0)
                              AppChip(
                                label: 'Withdraw all',
                                onTap: () {
                                  _amountController.text =
                                      formatAmount(available).replaceAll('.00', '');
                                  setState(() => _amount = available);
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pay to',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                            TertiaryButton(
                              label: 'Add account',
                              icon: Iconsax.add,
                              onPressed: () => context.push('/bank-accounts/add'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (accounts.isLoadingAccounts && accounts.accounts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (accounts.accounts.isEmpty)
                          AppCard(
                            padding: EdgeInsets.zero,
                            child: ListStatePlaceholder(
                              compact: true,
                              icon: Iconsax.bank_copy,
                              title: 'No bank account yet',
                              message:
                                  'Add the account you want the money paid into.',
                              actionLabel: 'Add a bank account',
                              primaryAction: true,
                              onAction: () => context.push('/bank-accounts/add'),
                            ),
                          )
                        else
                          for (final a in accounts.accounts)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: _AccountChoice(
                                account: a,
                                selected: selected?.id == a.id,
                                onTap: () => setState(() => _selectedAccountId = a.id),
                              ),
                            ),
                        const SizedBox(height: AppSpacing.md),
                        const InfoBanner(
                          tone: BannerTone.neutral,
                          icon: Iconsax.clock,
                          message:
                              'Most transfers arrive within minutes. Some banks take up to 24 hours.',
                        ),
                      ],
                    ),
                  ),
                ),
        },
      ),
    );
  }
}

class _AccountChoice extends StatelessWidget {
  final BankAccount account;
  final bool selected;
  final VoidCallback onTap;

  const _AccountChoice({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: '${account.bankName} ${account.maskedNumber}, ${account.accountName}',
      child: AppCard(
        onTap: onTap,
        color: selected ? colors.primarySurface : colors.surface,
        borderColor: selected ? AppColors.primary : colors.cardBorder,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                Iconsax.bank,
                size: 20,
                color: selected ? Colors.white : colors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '${account.bankName} · ${account.maskedNumber}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Iconsax.tick_circle, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ConfirmWithdrawal extends StatelessWidget {
  final double amount;
  final BankAccount account;

  const _ConfirmWithdrawal({required this.amount, required this.account});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Confirm withdrawal',
          style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.lg),
        MoneyText(
          amount,
          style: AppTextStyles.amountHero.copyWith(fontSize: 36),
          color: colors.textPrimary,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Iconsax.bank, color: colors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.accountName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '${account.bankName} · ${account.maskedNumber}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(
          label: 'Withdraw ${formatMoney(amount)}',
          onPressed: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: AppSpacing.xs),
        TertiaryButton(
          label: 'Cancel',
          expand: true,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

class _StatusView extends StatelessWidget {
  final WithdrawState state;

  const _StatusView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final wd = state.withdrawal;
    final (icon, color, title, body) = switch (state.stage) {
      WithdrawStage.completed => (
          Iconsax.tick_circle,
          AppColors.success,
          'Withdrawal sent',
          'The money is on its way to your bank.',
        ),
      WithdrawStage.failed => (
          Iconsax.close_circle,
          AppColors.error,
          'Withdrawal failed',
          state.errorMessage ??
              'The transfer could not be completed. The amount has been returned to your wallet.',
        ),
      _ => (
          Iconsax.clock,
          AppColors.primary,
          'Processing',
          'Your bank is confirming the transfer. This usually takes under a minute.',
        ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: color.withValues(alpha: context.isDarkMode ? 0.22 : 0.12),
              shape: BoxShape.circle,
            ),
            child: state.stage == WithdrawStage.pending
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: CircularProgressIndicator(strokeWidth: 3, color: color),
                  )
                : Icon(icon, size: 48, color: color),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (wd != null) ...[
            const SizedBox(height: AppSpacing.xl),
            MoneyText.fromString(
              wd.amount,
              currency: wd.currency,
              style: AppTextStyles.amountLarge,
              color: colors.textPrimary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Ref ${wd.reference}',
              style: AppTextStyles.bodySmall.copyWith(color: colors.textTertiary),
            ),
          ],
          const Spacer(flex: 3),
          PrimaryButton(
            label: 'Back to wallet',
            onPressed: () => context.go('/wallet'),
          ),
        ],
      ),
    );
  }
}

class _DisabledView extends StatelessWidget {
  const _DisabledView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListStatePlaceholder(
      icon: Iconsax.lock_1,
      title: 'Withdrawals are coming soon',
      message:
          'Payouts are not switched on yet. Your balance is safe and you will be able to withdraw as soon as they open.',
      actionLabel: 'Back',
      primaryAction: true,
      onAction: () => context.pop(),
    );
  }
}
