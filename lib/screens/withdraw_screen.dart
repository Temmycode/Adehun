import 'package:adehun_mvp/controllers/bank_account_controller.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/controllers/withdraw_controller.dart';
import 'package:adehun_mvp/core/utils/format_currency.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:adehun_mvp/domain/states/withdraw_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/currency_input_formatter.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _amountController = TextEditingController();
  String? _selectedAccountId;

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

  double? get _amount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', ''));

  Future<void> _confirmAndSubmit(BankAccount account) async {
    final amount = _amount;
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount');
      return;
    }
    final available = ref
        .read(walletDataControllerProvider)
        .maybeWhen(data: (d) => d.availableBalance, orElse: () => null);
    if (available != null && amount > available + 0.01) {
      _snack('That is more than your available balance');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm withdrawal'),
        content: Text(
          'Send ${formatMoney(amount)} to ${account.bankName} '
          '${account.maskedNumber} (${account.accountName})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref
        .read(withdrawControllerProvider.notifier)
        .submit(amount: amount.toStringAsFixed(2), bankAccountId: account.id);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final withdraw = ref.watch(withdrawControllerProvider);
    final accounts = ref.watch(bankAccountControllerProvider);
    final wallet = ref.watch(walletDataControllerProvider);

    ref.listen(withdrawControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null &&
          error != prev?.errorMessage &&
          next.stage != WithdrawStage.failed) {
        _snack(error);
        ref.read(withdrawControllerProvider.notifier).clearError();
      }
    });

    final selected =
        accounts.accounts.where((a) => a.id == _selectedAccountId).firstOrNull ??
        accounts.defaultAccount;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Withdraw', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: switch (withdraw.stage) {
        WithdrawStage.pending ||
        WithdrawStage.completed ||
        WithdrawStage.failed => _StatusView(state: withdraw),
        _ => withdraw.disabled
            ? const _DisabledView()
            : _FormView(
                amountController: _amountController,
                available: wallet.maybeWhen(
                  data: (d) => d.availableBalance,
                  orElse: () => null,
                ),
                accounts: accounts.accounts,
                isLoadingAccounts: accounts.isLoadingAccounts,
                selected: selected,
                onSelectAccount: (id) => setState(() => _selectedAccountId = id),
                onSubmit: selected == null || withdraw.isBusy
                    ? null
                    : () => _confirmAndSubmit(selected),
                isSubmitting: withdraw.isBusy,
              ),
      },
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController amountController;
  final double? available;
  final List<BankAccount> accounts;
  final bool isLoadingAccounts;
  final BankAccount? selected;
  final ValueChanged<String> onSelectAccount;
  final VoidCallback? onSubmit;
  final bool isSubmitting;

  const _FormView({
    required this.amountController,
    required this.available,
    required this.accounts,
    required this.isLoadingAccounts,
    required this.selected,
    required this.onSelectAccount,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            available == null
                ? 'Available balance: …'
                : 'Available balance: ${formatMoney(available!)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Text('Amount', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [CurrencyInputFormatter()],
            style: AppTextStyles.amountMedium,
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '₦ ',
              prefixStyle: AppTextStyles.amountMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pay to', style: AppTextStyles.labelLarge),
              TextButton(
                onPressed: () => context.push('/bank-accounts/add'),
                child: const Text('Add account'),
              ),
            ],
          ),
          if (isLoadingAccounts && accounts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (accounts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Add a bank account to withdraw to.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            )
          else
            ...accounts.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => onSelectAccount(a.id),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected?.id == a.id
                            ? AppColors.primary
                            : colors.cardBorder,
                        width: selected?.id == a.id ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected?.id == a.id
                              ? Iconsax.tick_circle
                              : Iconsax.bank_copy,
                          color: selected?.id == a.id
                              ? AppColors.primary
                              : colors.textTertiary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.accountName,
                                style: AppTextStyles.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${a.bankName} · ${a.maskedNumber}',
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
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Withdraw'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  final WithdrawState state;
  const _StatusView({required this.state});

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
        state.errorMessage ?? 'The transfer could not be completed. '
            'The amount has been returned to your wallet.',
      ),
      _ => (
        Iconsax.clock,
        AppColors.primary,
        'Processing',
        'Your bank is confirming the transfer. This usually takes under a minute.',
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.stage == WithdrawStage.pending)
            const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          else
            Icon(icon, size: 72, color: color),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (wd != null) ...[
            const SizedBox(height: 20),
            Text(
              formatMoneyString(wd.amount, currency: wd.currency),
              style: AppTextStyles.amountLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Ref ${wd.reference}',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/wallet'),
              child: const Text('Back to wallet'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisabledView extends StatelessWidget {
  const _DisabledView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.lock_1, size: 64, color: colors.textTertiary),
          const SizedBox(height: 20),
          Text('Withdrawals are coming soon', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'Payouts are not switched on yet. Your balance is safe and you '
            'will be able to withdraw as soon as they open.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}
