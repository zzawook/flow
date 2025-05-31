import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'setting_v1.g.dart';

@HiveType(typeId: 7)
class SettingsV1 {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final String theme;

  @HiveField(2)
  final double fontScale;

  @HiveField(3)
  final NotificationSetting notification;

  SettingsV1({
    required this.language,
    required this.theme,
    required this.fontScale,
    required this.notification,
  });

  SettingsV1 copyWith({
    String? language,
    String? theme,
    double? fontScale,
    NotificationSetting? notification,
  }) {
    return SettingsV1(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontScale: fontScale ?? this.fontScale,
      notification: notification ?? this.notification,
    );
  }

  factory SettingsV1.initial() {
    return SettingsV1(
      language: 'en',
      theme: 'light',
      fontScale: 1.0,
      notification: NotificationSetting.initial(),
    );
  }

  static SettingsV1 fromPrevVersion(Settings prev) {
    return SettingsV1(
      language: prev.language,
      theme: prev.theme,
      fontScale: prev.fontScale,
      notification: NotificationSetting.initial().copyWith(
        masterEnabled: prev.notification,
      ),
    );
  }
}
