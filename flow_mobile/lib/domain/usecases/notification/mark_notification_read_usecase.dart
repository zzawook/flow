import 'package:flow_mobile/domain/repositories/notification_repository.dart';

/// Use case for marking notifications as read
abstract class MarkNotificationReadUseCase {
  Future<void> execute(int id);
  Future<void> executeAll();
}

/// Implementation of mark notification read use case
class MarkNotificationReadUseCaseImpl implements MarkNotificationReadUseCase {
  final NotificationRepository _notificationRepository;

  MarkNotificationReadUseCaseImpl(this._notificationRepository);

  @override
  Future<void> execute(int id) async {
    await _notificationRepository.markNotificationAsRead(id);
  }

  @override
  Future<void> executeAll() async {
    await _notificationRepository.markAllNotificationsAsRead();
  }
}