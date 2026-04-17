import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/domain/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase
    implements UseCase<DataState<int>, void> {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsReadUseCase(this.notificationRepository);

  @override
  Future<DataState<int>> call({void params}) async {
    return await notificationRepository.markAllAsRead();
  }
}
