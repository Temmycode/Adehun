import 'package:adehun_mvp/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/utils/group_by_day.dart';
import '../domain/models/transaction.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/paginated_list_view.dart';
import '../widgets/skeletons.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(transactionsListControllerProvider);
      // The wallet has usually loaded page 1 already, and loadTransactions()
      // replaces the list, so only fetch on a cold entry.
      if (state.transactions.isEmpty && !state.isLoading) {
        ref.read(transactionsListControllerProvider.notifier).loadTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(transactionsListControllerProvider);
    final notifier = ref.read(transactionsListControllerProvider.notifier);
    final items = state.transactions;

    // A load-more failure keeps the list on screen, so the inline footer is
    // the primary signal; this makes sure it isn't missed off-screen.
    ref.listen(transactionsListControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage &&
          next.transactions.isNotEmpty) {
        showAppToast(context, next.errorMessage!, kind: ToastKind.error);
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppTopBar(title: 'Activity'),
      body: SafeArea(
        top: false,
        child: PaginatedListView<Transaction>(
          items: items,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          isLoading: state.isLoading,
          isLoadingMore: state.isLoadingMore,
          hasMore: state.hasMore,
          errorMessage: state.errorMessage,
          onLoadMore: notifier.loadMore,
          onRefresh: notifier.refresh,
          onRetry: notifier.loadTransactions,
          loadingBuilder: (_) => const TransactionListSkeleton(count: 9),
          emptyBuilder: (_) => ListStatePlaceholder(
            icon: Iconsax.receipt_2_copy,
            title: 'No activity yet',
            message:
                'Once you fund your wallet or complete an agreement, it shows up here.',
            actionLabel: 'Fund wallet',
            primaryAction: true,
            onAction: () => context.push('/fund-wallet'),
          ),
          errorBuilder: (_, message) => ListStatePlaceholder.error(
            heading: "Couldn't load activity",
            detail: message,
            onRetry: notifier.loadTransactions,
          ),
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, transaction, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (startsNewDay(items, index, (t) => t.createdAt))
                TransactionDayHeader(
                  day: transaction.createdAt,
                  first: index == 0,
                ),
              TransactionTile(transaction: transaction),
            ],
          ),
        ),
      ),
    );
  }
}
