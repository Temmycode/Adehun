import 'package:adehun_mvp/controllers/transaction_controller.dart';
import 'package:adehun_mvp/controllers/wallet_card_balance_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../domain/models/transaction.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_color_scheme.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/paginated_list_view.dart';
import '../widgets/skeletons.dart';
import '../widgets/wallet_card.dart';
import '../widgets/transaction_tile.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  /// The wallet only previews the latest few — the rest live on /transactions.
  static const _recentCount = 7;

  @override
  void initState() {
    super.initState();
    _initializeWalletData();
  }

  Future<void> _getTransactions() async {
    return await ref
        .read(transactionsListControllerProvider.notifier)
        .loadTransactions();
  }

  void _initializeWalletData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([_getTransactions()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(transactionsListControllerProvider);
    final notifier = ref.read(transactionsListControllerProvider.notifier);
    final recent = state.transactions.take(_recentCount).toList();

    ref.listen(transactionsListControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage &&
          next.transactions.isNotEmpty &&
          (ModalRoute.of(context)?.isCurrent ?? true)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          // Balance is websocket-fed, so only the ledger needs pulling.
          onRefresh: notifier.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Text(
                    'Wallet',
                    style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
                  ),
                ),
              ),

              // Wallet card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: WalletCard(
                    balanceVisible: balanceVisibleNotifier,
                    onFundWallet: () => context.push('/fund-wallet'),
                  ),
                ),
              ),

              // Transaction history header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
                  child: Text(
                    'Transaction History',
                    style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                  ),
                ),
              ),

              // Transaction list — bounded to the latest few, so `hasMore` is
              // false and this can never paginate.
              PaginatedSliverList<Transaction>(
                items: recent,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                isLoading: state.isLoading,
                hasMore: false,
                // SliverFillRemaining under the wallet card would overflow.
                fillViewportOnEmpty: false,
                errorMessage: state.errorMessage,
                onRetry: notifier.loadTransactions,
                loadingBuilder: (_) => const TransactionListSkeleton(count: 5),
                emptyBuilder: (_) => const ListStatePlaceholder(
                  compact: true,
                  icon: Iconsax.receipt_2_copy,
                  title: 'No transactions yet',
                  message: 'Fund your wallet to get started.',
                ),
                errorBuilder: (_, message) => ListStatePlaceholder.error(
                  compact: true,
                  heading: "Couldn't load transactions",
                  detail: message,
                  onRetry: notifier.loadTransactions,
                ),
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, transaction, _) =>
                    TransactionTile(transaction: transaction),
              ),

              // See more — only once the server reports more than we're showing.
              if (state.total > _recentCount)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => context.push('/transactions'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: colors.surfaceVariant,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See more',
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Iconsax.arrow_right_3,
                              size: 15,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
