import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/core/resources/usecase.dart';
import 'package:adehun_mvp/domain/notification_repository.dart';

class MarkNotificationsAsReadUseCase
    implements UseCase<DataState<int>, List<String>> {
  final NotificationRepository notificationRepository;

  MarkNotificationsAsReadUseCase(this.notificationRepository);

  @override
  Future<DataState<int>> call({List<String>? params}) async {
    return await notificationRepository.markAsRead(params ?? const []);
  }
}
