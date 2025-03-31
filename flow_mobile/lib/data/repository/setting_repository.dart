abstract class SettingRepository {
  Future<void> setLanguage(String language);
  Future<String> getLanguage();
  Future<void> setTheme(String theme);
  Future<String> getTheme();
  Future<void> setFontScale(double fontScale);
  Future<double> getFontScale();
  Future<void> setNotification(bool notification);
  Future<bool> getNotification();
}