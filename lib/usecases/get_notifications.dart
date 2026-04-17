import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/domain/models/notification_list_response.dart';
import 'package:adehun_mvp/domain/notification_repository.dart';
import 'package:adehun_mvp/usecases/params/get_notifications_params.dart';

class GetNotificationsUseCase
    implements
        UseCase<DataState<NotificationListResponse>, GetNotificationsParams> {
  final NotificationRepository notificationRepository;

  GetNotificationsUseCase(this.notificationRepository);

  @override
  Future<DataState<NotificationListResponse>> call({
    GetNotificationsParams? params,
  }) async {
    final p = params ?? const GetNotificationsParams();
    return await notificationRepository.getNotifications(
      skip: p.skip,
      limit: p.limit,
    );
  }
}
