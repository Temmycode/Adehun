import 'package:adehun_mvp/domain/models/notification_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NotificationListResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int total;

  const NotificationListResponse({
    this.notifications = const [],
    this.unreadCount = 0,
    this.total = 0,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListResponseToJson(this);
}
