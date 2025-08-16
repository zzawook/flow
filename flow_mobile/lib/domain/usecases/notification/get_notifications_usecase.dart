import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/repositories/notification_repository.dart';

/// Use case for getting notifications
abstract class GetNotificationsUseCase {
  Future<List<Notification>> execute();
}

/// Implementation of get notifications use case
class GetNotificationsUseCaseImpl implements GetNotificationsUseCase {
  final NotificationRepository _notificationRepository;

  GetNotificationsUseCaseImpl(this._notificationRepository);

  @override
  Future<List<Notification>> execute() async {
    return await _notificationRepository.getNotifications();
  }
}