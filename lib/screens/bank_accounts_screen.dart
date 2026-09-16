import 'package:adehun_mvp/controllers/bank_account_controller.dart';
import 'package:adehun_mvp/domain/models/bank.dart';
import 'package:adehun_mvp/widgets/list_state_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(bankAccountControllerProvider);
    final notifier = ref.read(bankAccountControllerProvider.notifier);

    ref.listen(bankAccountControllerProvider, (prev, next) {
      final error = next.errorMessage;
      if (error != null && error != prev?.errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error)));
        notifier.clearError();
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Bank Accounts', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/bank-accounts/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.add, color: Colors.white),
        label: const Text('Add account', style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => notifier.loadAccounts(force: true),
        child: state.isLoadingAccounts && state.accounts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.accounts.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  ListStatePlaceholder(
                    icon: Iconsax.bank_copy,
                    title: 'No bank accounts yet',
                    message:
                        'Add the account you want withdrawals paid into. '
                        'The account name is verified with your bank.',
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                itemCount: state.accounts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _AccountTile(
                  account: state.accounts[index],
                  onMakeDefault: () => notifier.setDefault(state.accounts[index].id),
                  onDelete: () => _confirmDelete(context, state.accounts[index]),
                ),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, BankAccount account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove bank account?'),
        content: Text(
          '${account.bankName} ${account.maskedNumber} will no longer be '
          'available for withdrawals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(bankAccountControllerProvider.notifier).remove(account.id);
    }
  }
}

class _AccountTile extends StatelessWidget {
  final BankAccount account;
  final VoidCallback onMakeDefault;
  final VoidCallback onDelete;

  const _AccountTile({
    required this.account,
    required this.onMakeDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: account.isDefault ? AppColors.primary : colors.cardBorder,
          width: account.isDefault ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.bank, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.accountName,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                  Text(
                    'Default',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'default') onMakeDefault();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              if (!account.isDefault)
                const PopupMenuItem(value: 'default', child: Text('Make default')),
              const PopupMenuItem(value: 'delete', child: Text('Remove')),
            ],
          ),
        ],
      ),
    );
  }
}
