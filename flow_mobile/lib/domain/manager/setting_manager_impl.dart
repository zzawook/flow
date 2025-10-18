import 'dart:convert';

import 'package:flow_mobile/domain/manager/setting_manager.dart';
import 'package:flow_mobile/domain/entity/notification_setting.dart';
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingManagerImpl implements SettingManager {
  final Box<SettingsV1> _settingsBox;

  // Singleton instance
  static SettingManagerImpl? _instance;

  // Private named constructor
  SettingManagerImpl._(this._settingsBox);

  // Asynchronous getter to obtain the singleton instance
  static Future<SettingManagerImpl> getInstance() async {
    if (_instance == null) {
      final box = await SecureHive.getBox<SettingsV1>('settingsBox');
      await box.put('settings', SettingsV1.initial());
      _instance = SettingManagerImpl._(box);
    }
    return _instance!;
  }

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
      throw Exception("Settings not found");
    }
    return settings.notification;
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
      throw Exception("Settings not found");
    }
    final updated = settings.copyWith(notification: notification);
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
  
  @override
  Future<void> clearSettings() {
    return _settingsBox.put('settings', SettingsV1.initial());
  }

  @override
  Future<void> fetchSettingsFromRemote() async {
    final apiService = getIt<ApiService>();
    final response = await apiService.getUserPreferenceJson();
    final settings = SettingsV1.fromJson(
      Map<String, dynamic>.from(
        response.preferenceJson.isNotEmpty
            ? await Future.value(jsonDecode(response.preferenceJson))
            : {},
      ),
    );

    setFontScale(settings.fontScale);
    setLanguage(settings.language);
    setTheme(settings.theme);
    setNotificationSetting(settings.notification);
    setDisplayBalanceOnHome(settings.displayBalanceOnHome);
  }
}
