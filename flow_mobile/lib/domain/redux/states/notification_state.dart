import 'package:flow_mobile/domain/entity/notification.dart';

class NotificationState {
  List<Notification> notifications;

  NotificationState({
    required this.notifications,
  });
  NotificationState copyWith({
    List<Notification>? notifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }
  factory NotificationState.initial() =>
      NotificationState(notifications: []);

  void addNotification(Notification notification) {
    notifications.add(notification);
  }
  
  void removeNotification(Notification notification) {
    notifications.remove(notification);
  }

  void clearNotifications() {
    notifications.clear();
  }

  void deleteNotificationOver7Days() {
    notifications.removeWhere((notification) =>
        DateTime.now().difference(notification.createdAt).inDays > 7);
  }

  bool hasUncheckedNotification() {
    return notifications.any((notification) => !notification.isChecked);
  }

  List<Notification> getNotification() {
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }
}