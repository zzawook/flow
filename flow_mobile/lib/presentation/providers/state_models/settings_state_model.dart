import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flow_mobile/domain/entity/setting_v1.dart';

part 'settings_state_model.freezed.dart';

@freezed
class SettingsStateModel with _$SettingsStateModel {
  const factory SettingsStateModel({
    required SettingsV1 settings,
  }) = _SettingsStateModel;

  factory SettingsStateModel.initial() => SettingsStateModel(
    settings: SettingsV1.initial(),
  );
}