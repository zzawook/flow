import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required String language,
    required String theme,
    required double fontScale,
    required bool notification,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  factory Settings.initial() {
    return const Settings(
      language: 'en',
      theme: 'light',
      fontScale: 1.0,
      notification: true,
    );
  }
}