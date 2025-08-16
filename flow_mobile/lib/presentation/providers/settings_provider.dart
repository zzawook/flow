import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/domain/entity/notification_setting.dart' as old_entity;
import 'package:flow_mobile/core/providers/providers.dart';

/// StateNotifier for Settings state management
class SettingsNotifier extends StateNotifier<SettingsStateModel> {
  final GetDisplayBalanceUseCase _getDisplayBalanceUseCase;
  final SetDisplayBalanceUseCase _setDisplayBalanceUseCase;
  final GetNotificationSettingsUseCase _getNotificationSettingsUseCase;
  final SetNotificationSettingsUseCase _setNotificationSettingsUseCase;
  final GetThemeUseCase _getThemeUseCase;
  final SetThemeUseCase _setThemeUseCase;
  final GetLanguageUseCase _getLanguageUseCase;
  final SetLanguageUseCase _setLanguageUseCase;
  final GetFontScaleUseCase _getFontScaleUseCase;
  final SetFontScaleUseCase _setFontScaleUseCase;

  SettingsNotifier(
    this._getDisplayBalanceUseCase,
    this._setDisplayBalanceUseCase,
    this._getNotificationSettingsUseCase,
    this._setNotificationSettingsUseCase,
    this._getThemeUseCase,
    this._setThemeUseCase,
    this._getLanguageUseCase,
    this._setLanguageUseCase,
    this._getFontScaleUseCase,
    this._setFontScaleUseCase,
  ) : super(SettingsStateModel.initial());

  /// Load all settings
  Future<void> loadSettings() async {
    try {
      // Load all settings in parallel
      final results = await Future.wait([
        _getDisplayBalanceUseCase.execute(),
        _getNotificationSettingsUseCase.execute(),
        _getThemeUseCase.execute(),
        _getLanguageUseCase.execute(),
        _getFontScaleUseCase.execute(),
      ]);

      final displayBalance = results[0] as bool;
      final notificationSettings = results[1] as NotificationSetting;
      final theme = results[2] as String;
      final language = results[3] as String;
      final fontScale = results[4] as double;

      // Update settings with loaded values
      final updatedSettings = state.settings.copyWith(
        displayBalanceOnHome: displayBalance,
        notification: _convertToOldNotificationSetting(notificationSettings),
        theme: theme,
        language: language,
        fontScale: fontScale,
      );

      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Update display balance setting
  Future<void> setDisplayBalance(bool displayBalance) async {
    try {
      await _setDisplayBalanceUseCase.execute(displayBalance);
      final updatedSettings = state.settings.copyWith(displayBalanceOnHome: displayBalance);
      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Toggle display balance setting
  Future<void> toggleDisplayBalanceOnHome() async {
    final currentValue = state.settings.displayBalanceOnHome;
    await setDisplayBalance(!currentValue);
  }

  /// Update notification settings
  Future<void> setNotificationSettings(NotificationSetting notificationSettings) async {
    try {
      await _setNotificationSettingsUseCase.execute(notificationSettings);
      final updatedSettings = state.settings.copyWith(notification: _convertToOldNotificationSetting(notificationSettings));
      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Update theme setting
  Future<void> setTheme(String theme) async {
    try {
      await _setThemeUseCase.execute(theme);
      final updatedSettings = state.settings.copyWith(theme: theme);
      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Update language setting
  Future<void> setLanguage(String language) async {
    try {
      await _setLanguageUseCase.execute(language);
      final updatedSettings = state.settings.copyWith(language: language);
      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Update font scale setting
  Future<void> setFontScale(double fontScale) async {
    try {
      await _setFontScaleUseCase.execute(fontScale);
      final updatedSettings = state.settings.copyWith(fontScale: fontScale);
      state = state.copyWith(settings: updatedSettings);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Toggle theme between light and dark
  Future<void> toggleTheme() async {
    final currentTheme = state.settings.theme;
    final newTheme = currentTheme == 'light' ? 'dark' : 'light';
    await setTheme(newTheme);
  }

  /// Toggle notification master setting
  Future<void> toggleNotificationMaster() async {
    final currentSettings = _convertFromOldNotificationSetting(state.settings.notification);
    final updatedNotificationSettings = currentSettings.copyWith(
      masterEnabled: !currentSettings.masterEnabled,
    );
    await setNotificationSettings(updatedNotificationSettings);
  }

  /// Toggle insight notification setting
  Future<void> toggleInsightNotification() async {
    final currentSettings = _convertFromOldNotificationSetting(state.settings.notification);
    final updatedNotificationSettings = currentSettings.copyWith(
      insightNotificationEnabled: !currentSettings.insightNotificationEnabled,
    );
    await setNotificationSettings(updatedNotificationSettings);
  }

  /// Toggle periodic reminder notification setting
  Future<void> togglePeriodicReminderNotification() async {
    final currentSettings = _convertFromOldNotificationSetting(state.settings.notification);
    final updatedNotificationSettings = currentSettings.copyWith(
      periodicNotificationEnabled: !currentSettings.periodicNotificationEnabled,
    );
    await setNotificationSettings(updatedNotificationSettings);
  }

  /// Toggle periodic reminder auto notification setting
  Future<void> togglePeriodicReminderAutoNotification() async {
    final currentSettings = _convertFromOldNotificationSetting(state.settings.notification);
    final updatedNotificationSettings = currentSettings.copyWith(
      periodicNotificationAutoEnabled: !currentSettings.periodicNotificationAutoEnabled,
    );
    await setNotificationSettings(updatedNotificationSettings);
  }

  /// Reset settings to default
  void resetSettings() {
    state = SettingsStateModel.initial();
  }

  /// Convert new NotificationSetting to old NotificationSetting for storage
  old_entity.NotificationSetting _convertToOldNotificationSetting(NotificationSetting newSetting) {
    return old_entity.NotificationSetting(
      masterEnabled: newSetting.masterEnabled,
      insightNotificationEnabled: newSetting.insightNotificationEnabled,
      periodicNotificationEnabled: newSetting.periodicNotificationEnabled,
      periodicNotificationAutoEnabled: newSetting.periodicNotificationAutoEnabled,
      periodicNotificationCron: newSetting.periodicNotificationCron,
    );
  }

  /// Convert old NotificationSetting to new NotificationSetting for use
  NotificationSetting _convertFromOldNotificationSetting(old_entity.NotificationSetting oldSetting) {
    return NotificationSetting(
      masterEnabled: oldSetting.masterEnabled,
      insightNotificationEnabled: oldSetting.insightNotificationEnabled,
      periodicNotificationEnabled: oldSetting.periodicNotificationEnabled,
      periodicNotificationAutoEnabled: oldSetting.periodicNotificationAutoEnabled,
      periodicNotificationCron: oldSetting.periodicNotificationCron,
    );
  }
}

/// Provider for SettingsNotifier
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsStateModel>((ref) {
  return SettingsNotifier(
    ref.read(getDisplayBalanceUseCaseProvider).value!,
    ref.read(setDisplayBalanceUseCaseProvider).value!,
    ref.read(getNotificationSettingsUseCaseProvider).value!,
    ref.read(setNotificationSettingsUseCaseProvider).value!,
    ref.read(getThemeUseCaseProvider).value!,
    ref.read(setThemeUseCaseProvider).value!,
    ref.read(getLanguageUseCaseProvider).value!,
    ref.read(setLanguageUseCaseProvider).value!,
    ref.read(getFontScaleUseCaseProvider).value!,
    ref.read(setFontScaleUseCaseProvider).value!,
  );
});

/// Convenience provider for accessing settings state
final settingsStateProvider = Provider<SettingsStateModel>((ref) {
  return ref.watch(settingsNotifierProvider);
});

/// Convenience provider for accessing settings
final settingsProvider = Provider<SettingsV1>((ref) {
  return ref.watch(settingsNotifierProvider).settings;
});

/// Convenience providers for specific settings
final displayBalanceProvider = Provider<bool>((ref) {
  return ref.watch(settingsNotifierProvider).settings.displayBalanceOnHome;
});

final notificationSettingsProvider = Provider<NotificationSetting>((ref) {
  final oldNotification = ref.watch(settingsNotifierProvider).settings.notification;
  return NotificationSetting(
    masterEnabled: oldNotification.masterEnabled,
    insightNotificationEnabled: oldNotification.insightNotificationEnabled,
    periodicNotificationEnabled: oldNotification.periodicNotificationEnabled,
    periodicNotificationAutoEnabled: oldNotification.periodicNotificationAutoEnabled,
    periodicNotificationCron: oldNotification.periodicNotificationCron,
  );
});

final themeProvider = Provider<String>((ref) {
  return ref.watch(settingsNotifierProvider).settings.theme;
});

final languageProvider = Provider<String>((ref) {
  return ref.watch(settingsNotifierProvider).settings.language;
});

final fontScaleProvider = Provider<double>((ref) {
  return ref.watch(settingsNotifierProvider).settings.fontScale;
});