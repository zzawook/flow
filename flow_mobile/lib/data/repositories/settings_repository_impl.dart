import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/repositories/settings_repository.dart';
import 'package:flow_mobile/data/datasources/local/settings_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/settings_remote_datasource.dart';

/// Implementation of SettingsRepository using data sources
/// Maintains identical behavior to SettingManagerImpl
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl({
    required SettingsLocalDataSource localDataSource,
    required SettingsRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<void> setLanguage(String language) {
    return _localDataSource.setLanguage(language);
  }

  @override
  Future<String> getLanguage() {
    return _localDataSource.getLanguage();
  }

  @override
  Future<void> setTheme(String theme) {
    return _localDataSource.setTheme(theme);
  }

  @override
  Future<String> getTheme() {
    return _localDataSource.getTheme();
  }

  @override
  Future<void> setFontScale(double fontScale) {
    return _localDataSource.setFontScale(fontScale);
  }

  @override
  Future<double> getFontScale() {
    return _localDataSource.getFontScale();
  }

  @override
  Future<void> setNotificationSetting(NotificationSetting notification) {
    return _localDataSource.setNotificationSetting(notification);
  }

  @override
  Future<NotificationSetting> getNotificationSetting() {
    return _localDataSource.getNotificationSetting();
  }

  @override
  Future<void> setDisplayBalanceOnHome(bool displayBalanceOnHome) {
    return _localDataSource.setDisplayBalanceOnHome(displayBalanceOnHome);
  }

  @override
  Future<bool> getDisplayBalanceOnHome() {
    return _localDataSource.getDisplayBalanceOnHome();
  }
}