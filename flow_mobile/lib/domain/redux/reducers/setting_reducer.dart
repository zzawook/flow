import 'package:flow_mobile/domain/redux/actions/setting_actions.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';

SettingsState settingsReducer(SettingsState state, dynamic action) {
  if (action is ToggleDarkModeAction) {
    return SettingsState(currency: state.currency, darkMode: !state.darkMode);
  }
  return state;
}
