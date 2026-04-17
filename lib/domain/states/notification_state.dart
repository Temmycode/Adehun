import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int total;
  final bool isLoadingMore;
  final bool isMarking;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.total = 0,
    this.isLoadingMore = false,
    this.isMarking = false,
  });

  bool get hasMore => notifications.length < total;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    int? total,
    bool? isLoadingMore,
    bool? isMarking,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarking: isMarking ?? this.isMarking,
    );
  }
}
