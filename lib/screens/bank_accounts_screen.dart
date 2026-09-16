import 'package:adehun_mvp/controllers/bank_account_controller.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_card.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/status_pill.dart';

class BankAccountsScreen extends ConsumerStatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  ConsumerState<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends ConsumerState<BankAccountsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bankAccountControllerProvider.notifier).loadAccounts();
    });
  }

  Future<void> _showOptions(BankAccount account) async {
    final notifier = ref.read(bankAccountControllerProvider.notifier);
    final choice = await showAppBottomSheet<String>(
      context,
      title: account.accountName,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!account.isDefault)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              leading: const Icon(Iconsax.star_1),
              title: const Text('Use for withdrawals by default'),
              onTap: () => Navigator.of(sheetContext).pop('default'),
            ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            leading: const Icon(Iconsax.trash, color: AppColors.error),
            title: const Text(
              'Remove account',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () => Navigator.of(sheetContext).pop('delete'),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == 'default') {
      await notifier.setDefault(account.id);
      if (mounted) showAppToast(context, 'Default account updated', kind: ToastKind.success);
    } else if (choice == 'delete') {
      await _confirmDelete(account);
    }
  }

  Future<void> _confirmDelete(BankAccount account) async {
    final confirmed = await showAppBottomSheet<bool>(
      context,
      builder: (sheetContext) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Remove this account?',
            style: AppTextStyles.h2.copyWith(color: sheetContext.colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${account.bankName} ${account.maskedNumber} will no longer be available for withdrawals.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: sheetContext.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Remove',
            tone: ButtonTone.danger,
            onPressed: () => Navigator.of(sheetContext).pop(true),
          ),
          const SizedBox(height: AppSpacing.xs),
          TertiaryButton(
            label: 'Keep it',
            expand: true,
            onPressed: () => Navigator.of(sheetContext).pop(false),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(bankAccountControllerProvider.notifier).remove(account.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(bankAccountControllerProvider);
    final notifier = ref.read(bankAccountControllerProvider.notifier);

    ref.listen(bankAccountControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null && error != prev?.errorMessage) {
        showAppToast(context, error, kind: ToastKind.error);
        notifier.clearError();
      }
    });

    final loading = state.isLoadingAccounts && state.accounts.isEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Bank accounts'),
      bottomNavigationBar: state.accounts.isEmpty
          ? null
          : BottomActionBar(
              primary: SecondaryButton(
                label: 'Add another account',
                icon: Iconsax.add,
                onPressed: () => context.push('/bank-accounts/add'),
              ),
            ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => notifier.loadAccounts(force: true),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : state.accounts.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: AppSpacing.huge),
                      ListStatePlaceholder(
                        icon: Iconsax.bank_copy,
                        title: 'No bank accounts yet',
                        message:
                            'Add the account you want withdrawals paid into. We confirm the account name with your bank.',
                        actionLabel: 'Add a bank account',
                        primaryAction: true,
                        onAction: () => context.push('/bank-accounts/add'),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.sm,
                      AppSpacing.gutter,
                      AppSpacing.xxl,
                    ),
                    itemCount: state.accounts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, index) => _AccountTile(
                      account: state.accounts[index],
                      onMore: () => _showOptions(state.accounts[index]),
                    ).entrance(context, index),
                  ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final BankAccount account;
  final VoidCallback onMore;

  const _AccountTile({required this.account, required this.onMore});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      onTap: onMore,
      borderColor: account.isDefault ? AppColors.primary : null,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Iconsax.bank, color: AppColors.primary),
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
                const SizedBox(height: 2),
                Text(
                  '${account.bankName} · ${account.maskedNumber}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                if (account.isDefault) ...[
                  const SizedBox(height: 6),
                  StatusPill(
                    label: 'Default',
                    foreground: AppColors.primary,
                    background: colors.primarySurface,
                    icon: Iconsax.star_1,
                    size: StatusPillSize.sm,
                  ),
                ],
              ],
            ),
          ),
          Icon(Iconsax.more_copy, color: colors.textTertiary),
        ],
      ),
    );
  }
}
