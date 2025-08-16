import 'package:flow_mobile/domain/entities/notification_setting.dart';

/// Repository interface for settings operations
/// Matches existing SettingManager method signatures for compatibility
abstract class SettingsRepository {
  /// Set application language
  Future<void> setLanguage(String language);
  
  /// Get current application language
  Future<String> getLanguage();
  
  /// Set application theme
  Future<void> setTheme(String theme);
  
  /// Get current application theme
  Future<String> getTheme();
  
  /// Set font scale
  Future<void> setFontScale(double fontScale);
  
  /// Get current font scale
  Future<double> getFontScale();
  
  /// Set notification settings
  Future<void> setNotificationSetting(NotificationSetting notification);
  
  /// Get notification settings
  Future<NotificationSetting> getNotificationSetting();
  
  /// Set display balance on home screen preference
  Future<void> setDisplayBalanceOnHome(bool displayBalanceOnHome);
  
  /// Get display balance on home screen preference
  Future<bool> getDisplayBalanceOnHome();
}