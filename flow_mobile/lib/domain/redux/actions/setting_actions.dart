// Action
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';

class ClearSettingStateAction {}

class SetSettingStateAction {
  final SettingsState settingState;

  SetSettingStateAction({required this.settingState});
}

class ToggleThemeAction {}

class ToggleNotificationMasterAction {}

class ToggleInsightNotificationAction {}

class TogglePeriodicReminderNotificationAction {}

class TogglePeriodicReminderAutoNotificationAction {}

class ToggleDisplayBalanceOnHomeAction {}

class UpdateSettingStateAction {
  final SettingsV1 setting;

  UpdateSettingStateAction(this.setting);
}