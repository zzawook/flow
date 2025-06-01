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

  @HiveField(4)
  final bool displayBalanceOnHome;

  SettingsV1({
    required this.language,
    required this.theme,
    required this.fontScale,
    required this.notification,
    required this.displayBalanceOnHome,
  });

  SettingsV1 copyWith({
    String? language,
    String? theme,
    double? fontScale,
    NotificationSetting? notification,
    bool? displayBalanceOnHome,
  }) {
    return SettingsV1(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontScale: fontScale ?? this.fontScale,
      notification: notification ?? this.notification,
      displayBalanceOnHome: displayBalanceOnHome ?? this.displayBalanceOnHome,
    );
  }

  factory SettingsV1.initial() {
    return SettingsV1(
      language: 'en',
      theme: 'light',
      fontScale: 1.0,
      notification: NotificationSetting.initial(),
      displayBalanceOnHome: true,
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
      displayBalanceOnHome: true,
    );
  }
}
