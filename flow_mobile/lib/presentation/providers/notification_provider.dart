import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/core/providers/providers.dart';

/// StateNotifier for Notification state management
class NotificationNotifier extends StateNotifier<NotificationStateModel> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;

  NotificationNotifier(
    this._getNotificationsUseCase,
    this._markNotificationReadUseCase,
    this._deleteNotificationUseCase,
  ) : super(NotificationStateModel.initial());

  /// Load all notifications
  Future<void> loadNotifications() async {
    try {
      final notifications = await _getNotificationsUseCase.execute();
      state = state.copyWith(notifications: notifications);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Add a new notification
  void addNotification(Notification notification) {
    state = state.addNotification(notification);
  }

  /// Remove a notification
  void removeNotification(Notification notification) {
    state = state.removeNotification(notification);
  }

  /// Clear all notifications
  void clearNotifications() {
    state = state.clearNotifications();
  }

  /// Delete notifications older than 7 days
  void deleteNotificationOver7Days() {
    state = state.deleteNotificationOver7Days();
  }

  /// Mark notification as read
  Future<void> markNotificationRead(int notificationId) async {
    try {
      await _markNotificationReadUseCase.execute(notificationId);
      // Update local state to reflect the change
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isChecked: true);
        }
        return notification;
      }).toList();
      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Delete a specific notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _deleteNotificationUseCase.execute(notificationId);
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != notificationId)
          .toList();
      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }
}

/// Provider for NotificationNotifier
final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, NotificationStateModel>((ref) {
  return NotificationNotifier(
    ref.read(getNotificationsUseCaseProvider).value!,
    ref.read(markNotificationReadUseCaseProvider).value!,
    ref.read(deleteNotificationUseCaseProvider).value!,
  );
});

/// Convenience provider for accessing notification state
final notificationStateProvider = Provider<NotificationStateModel>((ref) {
  return ref.watch(notificationNotifierProvider);
});

/// Convenience provider for accessing notifications list
final notificationsProvider = Provider<List<Notification>>((ref) {
  return ref.watch(notificationNotifierProvider).notifications;
});

/// Convenience provider for checking if there are unchecked notifications
final hasUncheckedNotificationProvider = Provider<bool>((ref) {
  return ref.watch(notificationNotifierProvider).hasUncheckedNotification();
});

/// Convenience provider for getting sorted notifications
final sortedNotificationsProvider = Provider<List<Notification>>((ref) {
  return ref.watch(notificationNotifierProvider).getNotification();
});