import 'package:flow_mobile/domain/entities/notification_setting.dart';

import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source interface for settings operations
/// Abstracts Hive storage operations
abstract class SettingsLocalDataSource {
  /// Set language preference
  Future<void> setLanguage(String language);
  
  /// Get language preference
  Future<String> getLanguage();
  
  /// Set theme preference
  Future<void> setTheme(String theme);
  
  /// Get theme preference
  Future<String> getTheme();
  
  /// Set font scale preference
  Future<void> setFontScale(double fontScale);
  
  /// Get font scale preference
  Future<double> getFontScale();
  
  /// Set notification settings
  Future<void> setNotificationSetting(NotificationSetting notification);
  
  /// Get notification settings
  Future<NotificationSetting> getNotificationSetting();
  
  /// Set display balance on home preference
  Future<void> setDisplayBalanceOnHome(bool displayBalanceOnHome);
  
  /// Get display balance on home preference
  Future<bool> getDisplayBalanceOnHome();
}

/// Implementation of SettingsLocalDataSource using Hive
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Box<SettingsV1> _settingsBox;

  SettingsLocalDataSourceImpl({required Box<SettingsV1> settingsBox}) 
      : _settingsBox = settingsBox;

  @override
  Future<double> getFontScale() async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    return settings.fontScale;
  }

  @override
  Future<String> getLanguage() async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    return settings.language;
  }

  @override
  Future<NotificationSetting> getNotificationSetting() async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception('Settings not found');
    }
    // Convert from old entity to new entity
    final oldNotification = settings.notification;
    return NotificationSetting(
      masterEnabled: oldNotification.masterEnabled,
      insightNotificationEnabled: oldNotification.insightNotificationEnabled,
      periodicNotificationEnabled: oldNotification.periodicNotificationEnabled,
      periodicNotificationAutoEnabled: oldNotification.periodicNotificationAutoEnabled,
      periodicNotificationCron: oldNotification.periodicNotificationCron,
    );
  }

  @override
  Future<String> getTheme() async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    return settings.theme;
  }

  @override
  Future<void> setFontScale(double fontScale) async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    final updated = settings.copyWith(fontScale: fontScale);
    await _settingsBox.put('settings', updated);
  }

  @override
  Future<void> setLanguage(String language) async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    final updated = settings.copyWith(language: language);
    await _settingsBox.put('settings', updated);
  }

  @override
  Future<void> setNotificationSetting(NotificationSetting notification) async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception('Settings not found');
    }
    // Convert from new entity to old entity for storage
    final oldNotification = settings.notification.copyWith(
      masterEnabled: notification.masterEnabled,
      insightNotificationEnabled: notification.insightNotificationEnabled,
      periodicNotificationEnabled: notification.periodicNotificationEnabled,
      periodicNotificationAutoEnabled: notification.periodicNotificationAutoEnabled,
      periodicNotificationCron: notification.periodicNotificationCron,
    );
    final updated = settings.copyWith(notification: oldNotification);
    await _settingsBox.put('settings', updated);
  }

  @override
  Future<void> setTheme(String theme) async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    final updated = settings.copyWith(theme: theme);
    await _settingsBox.put('settings', updated);
  }

  @override
  Future<bool> getDisplayBalanceOnHome() async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    return settings.displayBalanceOnHome;
  }

  @override
  Future<void> setDisplayBalanceOnHome(bool displayBalanceOnHome) async {
    final settings = _settingsBox.get('settings');
    if (settings == null) {
      throw Exception("Settings not found");
    }
    final updated = settings.copyWith(
      displayBalanceOnHome: displayBalanceOnHome,
    );
    await _settingsBox.put('settings', updated);
  }
}