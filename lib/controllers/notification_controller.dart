import 'dart:async';
import 'dart:developer';

import 'package:adehun_mvp/controllers/unread_count_controller.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/notification_list_response.dart';
import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:adehun_mvp/domain/states/notification_state.dart';
import 'package:adehun_mvp/usecases/params/get_notifications_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_controller.g.dart';

@Riverpod(keepAlive: false)
class NotificationController extends _$NotificationController {
  static const _pageSize = 20;

  @override
  FutureOr<NotificationState> build() async {
    return await _fetchPage(skip: 0);
  }

  Future<NotificationState> _fetchPage({required int skip}) async {
    final useCase = ref.read(getNotificationsUseCaseProvider);
    final result = await useCase(
      params: GetNotificationsParams(skip: skip, limit: _pageSize),
    );

    if (result is DataSuccess<NotificationListResponse> && result.data != null) {
      final page = result.data!;
      return NotificationState(
        notifications: page.notifications,
        unreadCount: page.unreadCount,
        total: page.total,
      );
    }

    if (result.exception != null) throw result.exception!;
    return const NotificationState();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(skip: 0));
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null) return;
    if (current.isLoadingMore) return;
    if (!current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final useCase = ref.read(getNotificationsUseCaseProvider);
      final result = await useCase(
        params: GetNotificationsParams(
          skip: current.notifications.length,
          limit: _pageSize,
        ),
      );

      if (result is DataSuccess<NotificationListResponse> &&
          result.data != null) {
        final page = result.data!;
        state = AsyncData(
          current.copyWith(
            notifications: [...current.notifications, ...page.notifications],
            unreadCount: page.unreadCount,
            total: page.total,
            isLoadingMore: false,
          ),
        );
      } else {
        state = AsyncData(current.copyWith(isLoadingMore: false));
      }
    } catch (err) {
      log(err.toString());
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> markAsRead(List<String> ids) async {
    final current = state.value;
    if (current == null || ids.isEmpty) return;

    final idSet = ids.toSet();
    final previouslyUnread = current.notifications
        .where((n) => idSet.contains(n.id) && !n.isRead)
        .length;

    if (previouslyUnread == 0 &&
        current.notifications.every(
          (n) => !idSet.contains(n.id) || n.isRead,
        )) {
      return;
    }

    final optimistic = current.copyWith(
      notifications: current.notifications
          .map((n) => idSet.contains(n.id) ? n.copyWith(isRead: true) : n)
          .toList(),
      unreadCount: (current.unreadCount - previouslyUnread).clamp(0, 1 << 31),
      isMarking: true,
    );
    state = AsyncData(optimistic);
    ref
        .read(unreadCountControllerProvider.notifier)
        .decrementBy(previouslyUnread);

    try {
      final useCase = ref.read(markNotificationsAsReadUseCaseProvider);
      final result = await useCase(params: ids);

      if (result is DataSuccess<int>) {
        state = AsyncData(optimistic.copyWith(isMarking: false));
      } else {
        state = AsyncData(current);
        await ref.read(unreadCountControllerProvider.notifier).refresh();
        if (result.exception != null) throw result.exception!;
      }
    } catch (err) {
      log(err.toString());
      state = AsyncData(current);
      await ref.read(unreadCountControllerProvider.notifier).refresh();
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    final current = state.value;
    if (current == null) return;

    final optimistic = current.copyWith(
      notifications: current.notifications
          .map((n) => n.isRead ? n : n.copyWith(isRead: true))
          .toList(),
      unreadCount: 0,
      isMarking: true,
    );
    state = AsyncData(optimistic);
    ref.read(unreadCountControllerProvider.notifier).markAllRead();

    try {
      final useCase = ref.read(markAllNotificationsAsReadUseCaseProvider);
      final result = await useCase();

      if (result is DataSuccess<int>) {
        state = AsyncData(optimistic.copyWith(isMarking: false));
      } else {
        state = AsyncData(current);
        await ref.read(unreadCountControllerProvider.notifier).refresh();
        if (result.exception != null) throw result.exception!;
      }
    } catch (err) {
      log(err.toString());
      state = AsyncData(current);
      await ref.read(unreadCountControllerProvider.notifier).refresh();
      rethrow;
    }
  }

  NotificationModel? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    for (final n in current.notifications) {
      if (n.id == id) return n;
    }
    return null;
  }
}
