import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/domain/models/notification_list_response.dart';

abstract class NotificationRepository {
  Future<DataState<NotificationListResponse>> getNotifications({
    int skip = 0,
    int limit = 20,
  });

  Future<DataState<int>> getUnreadCount();

  Future<DataState<int>> markAsRead(List<String> notificationIds);

  Future<DataState<int>> markAllAsRead();
}
