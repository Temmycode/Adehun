import 'package:adehun_mvp/controllers/transaction_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../domain/models/transaction.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_color_scheme.dart';
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
      // replaces the list — so only fetch on a cold entry (deep link, or the
      // wallet's own load failed).
      if (state.transactions.isEmpty && !state.isLoading) {
        ref
            .read(transactionsListControllerProvider.notifier)
            .loadTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(transactionsListControllerProvider);
    final notifier = ref.read(transactionsListControllerProvider.notifier);

    // A load-more failure keeps the list on screen, so the inline footer is the
    // primary signal — this just makes sure it isn't missed off-screen.
    ref.listen(transactionsListControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage &&
          next.transactions.isNotEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Transactions', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: PaginatedListView<Transaction>(
          items: state.transactions,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          isLoading: state.isLoading,
          isLoadingMore: state.isLoadingMore,
          hasMore: state.hasMore,
          errorMessage: state.errorMessage,
          onLoadMore: notifier.loadMore,
          onRefresh: notifier.refresh,
          onRetry: notifier.loadTransactions,
          loadingBuilder: (_) => const TransactionListSkeleton(count: 9),
          emptyBuilder: (_) => const ListStatePlaceholder(
            icon: Iconsax.receipt_2_copy,
            title: 'No transactions yet',
            message:
                'Once you fund your wallet or complete an\nagreement, it shows up here.',
          ),
          errorBuilder: (_, message) => ListStatePlaceholder.error(
            heading: "Couldn't load transactions",
            detail: message,
            onRetry: notifier.loadTransactions,
          ),
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, transaction, _) =>
              TransactionTile(transaction: transaction),
        ),
      ),
    );
  }
}
