import 'package:flow_mobile/domain/entity/setting_v1.dart';

class SettingsState {
  final SettingsV1 settings;

  SettingsState({required this.settings});

  factory SettingsState.initial() =>
      SettingsState(settings: SettingsV1.initial());
}
