import 'package:adehun_mvp/controllers/transaction_controller.dart';
import 'package:adehun_mvp/controllers/wallet_card_balance_notifier.dart';
import 'package:adehun_mvp/controllers/wallet_data_controller.dart';
import 'package:adehun_mvp/shell/app_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/utils/group_by_day.dart';
import '../domain/models/transaction.dart';
import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_motion.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_toast.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/paginated_list_view.dart';
import '../widgets/section_header.dart';
import '../widgets/skeletons.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/wallet_card.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  /// The wallet only previews the latest few; the rest live on /transactions.
  static const _recentCount = 7;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionsListControllerProvider.notifier).loadTransactions();
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
        showAppToast(context, next.errorMessage!, kind: ToastKind.error);
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => Future.wait([
            notifier.refresh(),
            ref.read(walletDataControllerProvider.notifier).refresh(),
          ]),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.md,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: Text(
                    'Wallet',
                    style: AppTextStyles.h1.copyWith(color: colors.textPrimary),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xl,
                    AppSpacing.gutter,
                    0,
                  ),
                  child: WalletCard(
                    balanceVisible: balanceVisibleNotifier,
                    onFundWallet: () => context.push('/fund-wallet'),
                    onWithdraw: () => context.push('/withdraw'),
                    onHistory: () => context.push('/transactions'),
                  ).entrance(context, 0),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xxl,
                    bottom: AppSpacing.xs,
                  ),
                  child: SectionHeader(
                    title: 'Recent activity',
                    actionLabel: state.total > _recentCount ? 'See all' : null,
                    onAction: () => context.push('/transactions'),
                  ),
                ),
              ),
              // Bounded to the latest few, so `hasMore` is false and this can
              // never paginate.
              PaginatedSliverList<Transaction>(
                items: recent,
                padding: AppInsets.screen,
                isLoading: state.isLoading,
                hasMore: false,
                // SliverFillRemaining under the wallet card would overflow.
                fillViewportOnEmpty: false,
                errorMessage: state.errorMessage,
                onRetry: notifier.loadTransactions,
                loadingBuilder: (_) => const TransactionListSkeleton(count: 5),
                emptyBuilder: (_) => ListStatePlaceholder(
                  compact: true,
                  icon: Iconsax.receipt_2_copy,
                  title: 'No activity yet',
                  message: 'Fund your wallet and it will show up here.',
                  actionLabel: 'Fund wallet',
                  onAction: () => context.push('/fund-wallet'),
                ),
                errorBuilder: (_, message) => ListStatePlaceholder.error(
                  compact: true,
                  heading: "Couldn't load activity",
                  detail: message,
                  onRetry: notifier.loadTransactions,
                ),
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, transaction, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (startsNewDay(recent, index, (t) => t.createdAt))
                      TransactionDayHeader(
                        day: transaction.createdAt,
                        first: index == 0,
                      ),
                    TransactionTile(transaction: transaction),
                  ],
                ),
              ),
              if (state.total > _recentCount)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.md,
                      AppSpacing.gutter,
                      0,
                    ),
                    child: SecondaryButton(
                      label: 'See all activity',
                      icon: Iconsax.arrow_right_3_copy,
                      onPressed: () => context.push('/transactions'),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: context.navBottomPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
