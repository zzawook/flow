import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source interface for notification operations
/// Abstracts Hive storage operations
abstract class NotificationLocalDataSource {
  /// Add a new notification to local storage
  Future<void> addNotification(Notification notification);
  
  /// Clear all notifications from local storage
  Future<void> clearNotifications();
  
  /// Get all notifications from local storage
  Future<List<Notification>> getNotifications();
  
  /// Mark a specific notification as read
  Future<void> markNotificationAsRead(int id);
  
  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead();
  
  /// Delete a specific notification
  Future<void> deleteNotification(int id);
}

/// Implementation of NotificationLocalDataSource using Hive
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final Box<Notification> _notificationBox;

  NotificationLocalDataSourceImpl({required Box<Notification> notificationBox}) 
      : _notificationBox = notificationBox;

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