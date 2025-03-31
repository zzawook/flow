import 'package:flow_mobile/domain/redux/actions/setting_actions.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';

SettingsState settingsReducer(SettingsState state, dynamic action) {
  if (action is ToggleDarkModeAction) {
    return SettingsState(settings: state.settings.copyWith(theme: state.settings.theme));
  }
  return state;
}
