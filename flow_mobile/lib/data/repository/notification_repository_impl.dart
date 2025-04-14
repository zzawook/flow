import 'package:flow_mobile/data/repository/notification_repository.dart';
import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Box<Notification> _notificationBox;

  // Singleton instance
  static NotificationRepositoryImpl? _instance;

  // Private named constructor
  NotificationRepositoryImpl._(this._notificationBox);

  // Asynchronous getter to obtain the singleton instance
  static Future<NotificationRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final box = await Hive.openBox<Notification>('notificationBox');
      _instance = NotificationRepositoryImpl._(box);
    }
    return _instance!;
  }

  @override
  Future<void> addNotification(Notification notification) {
    return _notificationBox.put(notification.id, notification);
  }
  
  @override
  Future<void> clearNotifications() {
    return _notificationBox.clear();
  }
  
  @override
  Future<List<Notification>> getNotifications() {
    return Future.value(_notificationBox.values.toList());
  }
  
  @override
  Future<void> deleteNotification(int id) {
    return _notificationBox.delete(id);
  }
  
  @override
  Future<void> markAllNotificationsAsRead() {
    final notifications = _notificationBox.values.toList();
    for (var notification in notifications) {
      notification = notification.copyWith(isChecked: true);
      _notificationBox.put(notification.id, notification);
    }
    return Future.value();
  }
  
  @override
  Future<void> markNotificationAsRead(int id) {
    final notification = _notificationBox.get(id);
    if (notification != null) {
      final markAsReadNotification = notification.copyWith(isChecked: true);
      return _notificationBox.put(notification.id, markAsReadNotification);
    }
    return Future.value();
  }
}
