import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/entity/notification.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationManagerImpl implements NotificationManager {
  final Box<Notification> _notificationBox;

  // Singleton instance
  static NotificationManagerImpl? _instance;

  // Private named constructor
  NotificationManagerImpl._(this._notificationBox);

  // Asynchronous getter to obtain the singleton instance
  static Future<NotificationManagerImpl> getInstance() async {
    if (_instance == null) {
      final box = await Hive.openBox<Notification>('notificationBox');
      _instance = NotificationManagerImpl._(box);
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
