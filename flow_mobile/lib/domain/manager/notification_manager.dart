import 'package:flow_mobile/domain/entity/notification.dart';

abstract class NotificationManager {
  Future<void> addNotification(Notification notification);
  Future<void> clearNotifications();
  Future<List<Notification>> getNotifications();
  Future<void> markNotificationAsRead(int id);
  Future<void> markAllNotificationsAsRead();
  Future<void> deleteNotification(int id);

  Future<void> fetchNotificationsFromRemote() async {}
}