import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

part 'notification_state_model.freezed.dart';

@freezed
class NotificationStateModel with _$NotificationStateModel {
  const factory NotificationStateModel({
    @Default([]) List<Notification> notifications,
  }) = _NotificationStateModel;

  factory NotificationStateModel.initial() => const NotificationStateModel();
}

// Extension methods to mirror the existing Redux state functionality
extension NotificationStateModelExtensions on NotificationStateModel {
  NotificationStateModel addNotification(Notification notification) {
    return copyWith(notifications: [...notifications, notification]);
  }

  NotificationStateModel removeNotification(Notification notification) {
    return copyWith(
      notifications: notifications.where((n) => n != notification).toList(),
    );
  }

  NotificationStateModel clearNotifications() {
    return copyWith(notifications: []);
  }

  NotificationStateModel deleteNotificationOver7Days() {
    final filteredNotifications = notifications
        .where((notification) =>
            DateTime.now().difference(notification.createdAt).inDays <= 7)
        .toList();
    return copyWith(notifications: filteredNotifications);
  }

  bool hasUncheckedNotification() {
    return notifications.any((notification) => !notification.isChecked);
  }

  List<Notification> getNotification() {
    final sortedNotifications = [...notifications];
    sortedNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedNotifications;
  }
}