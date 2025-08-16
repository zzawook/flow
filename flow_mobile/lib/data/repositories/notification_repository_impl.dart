import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/repositories/notification_repository.dart';
import 'package:flow_mobile/data/datasources/local/notification_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/notification_remote_datasource.dart';

/// Implementation of NotificationRepository using data sources
/// Maintains identical behavior to NotificationManagerImpl
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _localDataSource;
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({
    required NotificationLocalDataSource localDataSource,
    required NotificationRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<void> addNotification(Notification notification) {
    return _localDataSource.addNotification(notification);
  }

  @override
  Future<void> clearNotifications() {
    return _localDataSource.clearNotifications();
  }

  @override
  Future<List<Notification>> getNotifications() {
    return _localDataSource.getNotifications();
  }

  @override
  Future<void> markNotificationAsRead(int id) {
    return _localDataSource.markNotificationAsRead(id);
  }

  @override
  Future<void> markAllNotificationsAsRead() {
    return _localDataSource.markAllNotificationsAsRead();
  }

  @override
  Future<void> deleteNotification(int id) {
    return _localDataSource.deleteNotification(id);
  }
}