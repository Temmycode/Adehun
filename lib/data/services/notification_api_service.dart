import 'package:adehun_mvp/constants/urls.dart';
import 'package:adehun_mvp/domain/models/mark_read_request.dart';
import 'package:adehun_mvp/domain/models/mark_read_response.dart';
import 'package:adehun_mvp/domain/models/notification_list_response.dart';
import 'package:adehun_mvp/domain/models/unread_count_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class NotificationApiService {
  factory NotificationApiService(Dio dio, {String? baseUrl}) =
      _NotificationApiService;

  @GET(getNotificationsUrl)
  Future<HttpResponse<NotificationListResponse>> getNotifications({
    @Query('skip') int skip = 0,
    @Query('limit') int limit = 20,
  });

  @GET(getUnreadNotificationsCountUrl)
  Future<HttpResponse<UnreadCountResponse>> getUnreadCount();

  @PATCH(markNotificationsReadUrl)
  Future<HttpResponse<MarkReadResponse>> markAsRead(
    @Body() MarkReadRequest body,
  );

  @PATCH(markAllNotificationsReadUrl)
  Future<HttpResponse<MarkReadResponse>> markAllAsRead();
}
