import 'package:flow_mobile/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<void> addNotification(Notification notification);
  Future<void> clearNotifications();
  Future<List<Notification>> getNotifications();
  Future<void> markNotificationAsRead(int id);
  Future<void> markAllNotificationsAsRead();
  Future<void> deleteNotification(int id);
}