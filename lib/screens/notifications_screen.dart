import 'package:adehun_mvp/controllers/notification_controller.dart';
import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:adehun_mvp/domain/models/notification_type.dart';
import 'package:adehun_mvp/domain/states/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_color_scheme.dart';
import '../theme/app_tokens.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_toast.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/list_state_placeholder.dart';
import '../widgets/notification_tile.dart';
import '../widgets/skeletons.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(notificationControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _handleTap(NotificationModel n) async {
    if (!n.isRead) {
      try {
        await ref
            .read(notificationControllerProvider.notifier)
            .markAsRead([n.id]);
      } catch (_) {
        if (!mounted) return;
        showAppToast(
          context,
          "Couldn't mark the notification as read",
          kind: ToastKind.error,
        );
      }
    }
    if (!mounted) return;
    final route = _routeFor(n);
    if (route != null) context.push(route);
  }

  String? _routeFor(NotificationModel n) {
    if (n.isAgreementAccepted || n.isAgreementDeclined) return null;

    switch (n.notificationType) {
      case NotificationType.invitationReceived:
        // Route by id only; the screen fetches the invitation itself.
        final id = n.agreementId ??
            ((n.metadata?['agreement'] as Map<String, dynamic>?)?['id']
                as String?);
        return id == null ? null : '/agreement-invitation/$id';
      case NotificationType.agreementAccepted:
      case NotificationType.agreementDeclined:
        return null;
      case NotificationType.agreementCompleted:
      case NotificationType.agreementCancelled:
      // Escrow and dispute activity both belong to an agreement. Dispute
      // notifications deliberately do NOT go to '/dispute/:id', which is the
      // raise-a-dispute form, not a place to read one.
      case NotificationType.escrowFunded:
      case NotificationType.escrowReleased:
      case NotificationType.escrowRefunded:
      case NotificationType.disputeRaised:
      case NotificationType.disputeEvidenceAdded:
      case NotificationType.disputeUnderReview:
      case NotificationType.disputeResolved:
        final id = n.agreementId;
        return id == null ? null : '/agreement/$id';
      case NotificationType.conditionAdded:
      case NotificationType.conditionUpdated:
        final conditionId = n.conditionId;
        if (conditionId != null) return '/condition/$conditionId';
        final agreementId = n.agreementId;
        return agreementId == null ? null : '/agreement/$agreementId';
      case NotificationType.walletCredited:
      case NotificationType.withdrawalCompleted:
      case NotificationType.withdrawalFailed:
        return '/wallet';
      case NotificationType.general:
        return null;
    }
  }

  Future<void> _handleMarkAllRead() async {
    try {
      await ref.read(notificationControllerProvider.notifier).markAllAsRead();
    } catch (_) {
      if (!mounted) return;
      showAppToast(
        context,
        "Couldn't mark all notifications as read",
        kind: ToastKind.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final asyncState = ref.watch(notificationControllerProvider);
    final unreadCount = asyncState.maybeWhen(
      data: (s) => s.unreadCount,
      orElse: () => 0,
    );
    final notifier = ref.read(notificationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppTopBar(
        title: 'Notifications',
        subtitle: unreadCount > 0 ? '$unreadCount unread' : null,
        actions: [
          if (unreadCount > 0)
            TertiaryButton(label: 'Mark all read', onPressed: _handleMarkAllRead),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: notifier.refresh,
        child: asyncState.when(
          data: (state) => _NotificationsList(
            state: state,
            scrollController: _scrollController,
            onTapNotification: _handleTap,
          ),
          loading: () => const NotificationListSkeleton(),
          error: (err, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: AppSpacing.huge),
              ListStatePlaceholder.error(
                heading: "Couldn't load notifications",
                detail: 'Check your connection and try again.',
                onRetry: notifier.refresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final NotificationState state;
  final ScrollController scrollController;
  final void Function(NotificationModel) onTapNotification;

  const _NotificationsList({
    required this.state,
    required this.scrollController,
    required this.onTapNotification,
  });

  @override
  Widget build(BuildContext context) {
    if (state.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: AppSpacing.huge),
          ListStatePlaceholder(
            icon: Iconsax.notification_bing_copy,
            title: "You're all caught up",
            message:
                "We'll let you know when someone accepts, funds, delivers or approves.",
          ),
        ],
      );
    }

    final itemCount = state.notifications.length + (state.hasMore ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= state.notifications.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final notification = state.notifications[index];
        return NotificationTile(
          notification: notification,
          onTap: () => onTapNotification(notification),
        );
      },
    );
  }
}
