import 'dart:convert';

import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/domain/redux/actions/setting_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> getSettingJsonThunk() {
  return (Store<FlowState> store) async {
    final apiService = getIt<ApiService>();
    final result = await apiService.getUserPreferenceJson();

    if (result.preferenceJson.isNotEmpty) {
      final preferenceJson = result.preferenceJson;
      // Parse the preferenceJson into SettingV1
      final setting = SettingsV1.fromJson(
        Map<String, dynamic>.from(
          await Future.value(
            preferenceJson.isNotEmpty ? jsonDecode(preferenceJson) : {},
          ),
        ),
      );
      store.dispatch(UpdateSettingStateAction(setting));
    }
  };
}

ThunkAction<FlowState> updateThemeAction(String newTheme) {
  return (Store<FlowState> store) async {
    final currentSetting = store.state.settingsState.settings;

    if (newTheme != "light" && newTheme != "dark") {
      // Invalid theme, do nothing
      return;
    }

    final apiService = getIt<ApiService>();
    final updatedSettings = currentSetting.copyWith(theme: newTheme);
    final user = store.state.userState.user;

    await apiService.updateUserProfile(
      user!,
      settingsJson: updatedSettings.toJson(),
    );
    store.dispatch(ToggleThemeAction());
  };
}
