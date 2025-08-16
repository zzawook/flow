import 'package:flow_mobile/domain/entities/notification.dart';

/// Repository interface for notification operations
/// Matches existing NotificationManager method signatures for compatibility
abstract class NotificationRepository {
  /// Add a new notification
  Future<void> addNotification(Notification notification);
  
  /// Clear all notifications
  Future<void> clearNotifications();
  
  /// Get all notifications
  Future<List<Notification>> getNotifications();
  
  /// Mark a notification as read by ID
  Future<void> markNotificationAsRead(int id);
  
  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead();
  
  /// Delete a notification by ID
  Future<void> deleteNotification(int id);
}