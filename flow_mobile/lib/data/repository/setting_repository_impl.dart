import 'package:flow_mobile/data/repository/setting_repository.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingRepositoryImpl implements SettingRepository {
  final Box<Settings> _settingsBox;

  // Singleton instance
  static SettingRepositoryImpl? _instance;

  // Private named constructor
  SettingRepositoryImpl._(this._settingsBox);

  // Asynchronous getter to obtain the singleton instance
  static Future<SettingRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final box = await Hive.openBox<Settings>('settingsBox');
      await box.put('settings', Settings.initial());
      _instance = SettingRepositoryImpl._(box);
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
  Future<bool> getNotification() async {
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
  Future<void> setNotification(bool notification) async {
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
}
