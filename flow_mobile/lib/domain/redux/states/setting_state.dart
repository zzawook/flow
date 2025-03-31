import 'package:flow_mobile/domain/entities/setting.dart';

class SettingsState {
  final Settings settings;

  SettingsState({required this.settings});

  factory SettingsState.initial() =>
      SettingsState(settings: Settings.initial());
}
