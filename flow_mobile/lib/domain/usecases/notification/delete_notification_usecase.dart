import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/repositories/notification_repository.dart';

/// Use case for deleting notifications
abstract class DeleteNotificationUseCase {
  Future<void> execute(int id);
  Future<void> executeAll();
  Future<void> executeCreate(Notification notification);
}

/// Implementation of delete notification use case
class DeleteNotificationUseCaseImpl implements DeleteNotificationUseCase {
  final NotificationRepository _notificationRepository;

  DeleteNotificationUseCaseImpl(this._notificationRepository);

  @override
  Future<void> execute(int id) async {
    await _notificationRepository.deleteNotification(id);
  }

  @override
  Future<void> executeAll() async {
    await _notificationRepository.clearNotifications();
  }

  @override
  Future<void> executeCreate(Notification notification) async {
    await _notificationRepository.addNotification(notification);
  }
}