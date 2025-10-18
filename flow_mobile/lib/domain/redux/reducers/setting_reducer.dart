import 'package:flow_mobile/domain/redux/actions/setting_actions.dart';
import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';

SettingsState settingsReducer(SettingsState state, dynamic action) {
  if (action is ClearSettingStateAction) {
    return SettingsState.initial();
  }
  if (action is SetSettingStateAction) {
    return action.settingState;
  }
  if (action is UpdateSettingStateAction) {
    return SettingsState(settings: action.setting);
  }
  if (action is ToggleThemeAction) {
    if (state.settings.theme == "light") {
      return SettingsState(settings: state.settings.copyWith(theme: "dark"));
    } else {
      return SettingsState(settings: state.settings.copyWith(theme: "light"));
    }
  }
  if (action is ToggleNotificationMasterAction) {
    return SettingsState(
      settings: state.settings.copyWith(
        notification: state.settings.notification.copyWith(
          masterEnabled: !state.settings.notification.masterEnabled,
        ),
      ),
    );
  }
  if (action is ToggleInsightNotificationAction) {
    return SettingsState(
      settings: state.settings.copyWith(
        notification: state.settings.notification.copyWith(
          insightNotificationEnabled:
              !state.settings.notification.insightNotificationEnabled,
        ),
      ),
    );
  }
  if (action is TogglePeriodicReminderNotificationAction) {
    return SettingsState(
      settings: state.settings.copyWith(
        notification: state.settings.notification.copyWith(
          periodicNotificationEnabled:
              !state.settings.notification.periodicNotificationEnabled,
        ),
      ),
    );
  }
  if (action is TogglePeriodicReminderAutoNotificationAction) {
    return SettingsState(
      settings: state.settings.copyWith(
        notification: state.settings.notification.copyWith(
          periodicNotificationAutoEnabled:
              !state.settings.notification.periodicNotificationAutoEnabled,
        ),
      ),
    );
  }
  if (action is ToggleDisplayBalanceOnHomeAction) {
    return SettingsState(
      settings: state.settings.copyWith(
        displayBalanceOnHome: !state.settings.displayBalanceOnHome,
      ),
    );
  }
  if (action is DeleteUserAction) {
    return SettingsState.initial();
  }
  return state;
}
