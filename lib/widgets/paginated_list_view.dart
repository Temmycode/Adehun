import 'package:flutter/material.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'list_state_placeholder.dart';

typedef PaginatedItemBuilder<T> =
    Widget Function(BuildContext context, T item, int index);

typedef PaginatedErrorBuilder =
    Widget Function(BuildContext context, String message);

/// Sliver core of the pagination widget.
///
/// Given a list plus the flags every paginated controller in this app already
/// exposes, it picks between skeleton, empty, error, and the real list with a
/// load-more footer. It owns no scroll state.
///
/// Drop this into an existing [CustomScrollView] when the screen already has
/// header slivers or manages its own [ScrollController] — or when a list is
/// deliberately bounded and never paginates (pass `hasMore: false`). Use
/// [PaginatedListView] when you want the scroll listener and pull-to-refresh
/// wired up for you.
class PaginatedSliverList<T> extends StatelessWidget {
  final List<T> items;
  final PaginatedItemBuilder<T> itemBuilder;

  /// Rendered between rows, never after the last one.
  final IndexedWidgetBuilder? separatorBuilder;

  /// First-page load. Only honoured while [items] is empty.
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  /// Non-null renders the full error state when [items] is empty, or an inline
  /// "couldn't load more" footer when it isn't.
  final String? errorMessage;
  final VoidCallback? onRetry;

  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final PaginatedErrorBuilder? errorBuilder;
  final WidgetBuilder? loadMoreBuilder;

  final EdgeInsetsGeometry padding;

  /// Centres the empty/error state in the remaining viewport. Turn this off
  /// when the list sits below tall header slivers, where it would overflow.
  final bool fillViewportOnEmpty;

  const PaginatedSliverList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
    this.onRetry,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadMoreBuilder,
    this.padding = EdgeInsets.zero,
    this.fillViewportOnEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      // Skeletons sit at the top so they line up with where the rows will land.
      if (isLoading) {
        return SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(
            child: loadingBuilder?.call(context) ?? const _DefaultLoading(),
          ),
        );
      }

      final message = errorMessage;
      final Widget child = message != null
          ? (errorBuilder?.call(context, message) ??
                ListStatePlaceholder.error(detail: message, onRetry: onRetry))
          : (emptyBuilder?.call(context) ?? const SizedBox.shrink());

      return SliverPadding(
        padding: padding,
        sliver: fillViewportOnEmpty
            ? SliverFillRemaining(hasScrollBody: false, child: child)
            : SliverToBoxAdapter(child: child),
      );
    }

    final showFooter = hasMore || isLoadingMore || errorMessage != null;

    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= items.length) {
            final message = errorMessage;
            if (message != null && !isLoadingMore) {
              return _LoadMoreError(message: message, onRetry: onRetry);
            }
            return loadMoreBuilder?.call(context) ?? const _DefaultLoadMore();
          }

          final row = itemBuilder(context, items[index], index);
          final separator = separatorBuilder;
          if (separator == null || index == items.length - 1) return row;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [row, separator(context, index)],
          );
        }, childCount: items.length + (showFooter ? 1 : 0)),
      ),
    );
  }
}

/// Scrollable, refreshable, infinitely-paginating list.
///
/// Wraps [PaginatedSliverList] in a [CustomScrollView] and calls [onLoadMore]
/// as the viewport nears the end. Extra slivers can be stacked above
/// ([headerSlivers]) or below ([footerSlivers]) so a screen with a hero card
/// still has a single scroll view.
class PaginatedListView<T> extends StatefulWidget {
  final List<T> items;
  final PaginatedItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  /// Called as the viewport nears the end. Safe to call repeatedly — this
  /// widget short-circuits on [isLoading]/[isLoadingMore]/`!hasMore`, and
  /// controllers are expected to guard re-entry too.
  final VoidCallback onLoadMore;

  /// Null hides the [RefreshIndicator].
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;

  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final PaginatedErrorBuilder? errorBuilder;
  final WidgetBuilder? loadMoreBuilder;

  final EdgeInsetsGeometry padding;

  /// Pass one in to share it with a scroll-to-top button or a SliverAppBar.
  /// When null the widget creates and disposes its own.
  final ScrollController? controller;

  /// Pixels from the bottom at which [onLoadMore] fires.
  final double loadMoreThreshold;

  final List<Widget> headerSlivers;
  final List<Widget> footerSlivers;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    this.separatorBuilder,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
    this.onRefresh,
    this.onRetry,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadMoreBuilder,
    this.padding = EdgeInsets.zero,
    this.controller,
    this.loadMoreThreshold = 240,
    this.headerSlivers = const <Widget>[],
    this.footerSlivers = const <Widget>[],
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _attach(widget.controller);
    _scheduleViewportCheck();
  }

  @override
  void didUpdateWidget(covariant PaginatedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _detach();
      _attach(widget.controller);
    }
    if (widget.items.length != oldWidget.items.length) {
      _scheduleViewportCheck();
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  void _attach(ScrollController? external) {
    _ownsController = external == null;
    _controller = external ?? ScrollController();
    _controller.addListener(_onScroll);
  }

  void _detach() {
    _controller.removeListener(_onScroll);
    if (_ownsController) _controller.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >=
        position.maxScrollExtent - widget.loadMoreThreshold) {
      _maybeLoadMore();
    }
  }

  void _maybeLoadMore() {
    if (widget.isLoading || widget.isLoadingMore || !widget.hasMore) return;
    // Wait for an explicit retry — otherwise a failing endpoint turns into an
    // infinite retry loop every time the threshold is crossed.
    if (widget.errorMessage != null) return;
    widget.onLoadMore();
  }

  /// A page that doesn't fill the viewport can never be scrolled, so the
  /// listener would never fire and the list would strand. Nudge it once per
  /// layout instead; it stops when [PaginatedListView.hasMore] flips false.
  void _scheduleViewportCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      if (_controller.position.maxScrollExtent <= 0) _maybeLoadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      controller: _controller,
      // Set once here so pull-to-refresh survives the empty and error states.
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        ...widget.headerSlivers,
        PaginatedSliverList<T>(
          items: widget.items,
          itemBuilder: widget.itemBuilder,
          separatorBuilder: widget.separatorBuilder,
          isLoading: widget.isLoading,
          isLoadingMore: widget.isLoadingMore,
          hasMore: widget.hasMore,
          errorMessage: widget.errorMessage,
          onRetry: widget.onRetry,
          loadingBuilder: widget.loadingBuilder,
          emptyBuilder: widget.emptyBuilder,
          errorBuilder: widget.errorBuilder,
          loadMoreBuilder: widget.loadMoreBuilder,
          padding: widget.padding,
          fillViewportOnEmpty: widget.headerSlivers.isEmpty,
        ),
        ...widget.footerSlivers,
      ],
    );

    final onRefresh = widget.onRefresh;
    if (onRefresh == null) return scrollView;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: scrollView,
    );
  }
}

class _DefaultLoading extends StatelessWidget {
  const _DefaultLoading();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(24),
    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
  );
}

class _DefaultLoadMore extends StatelessWidget {
  const _DefaultLoadMore();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    ),
  );
}

class _LoadMoreError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _LoadMoreError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
