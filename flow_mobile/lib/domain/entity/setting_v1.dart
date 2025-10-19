import 'package:flow_mobile/domain/entity/notification_setting.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'setting_v1.g.dart';

@HiveType(typeId: 4)
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

  String toJson() {
    return '''{
      "language": "$language",
      "theme": "$theme",
      "fontScale": $fontScale,
      "notification": {
        "masterEnabled": ${notification.masterEnabled},
        "insightNotificationEnabled": ${notification.insightNotificationEnabled},
        "periodicNotificationEnabled": ${notification.periodicNotificationEnabled},
        "periodicNotificationAutoEnabled": ${notification.periodicNotificationAutoEnabled},
        "periodicNotificationCron": [${notification.periodicNotificationCron.map((e) => '"$e"').join(', ')}]
      },
      "displayBalanceOnHome": $displayBalanceOnHome
    }''';
  }

  factory SettingsV1.fromJson(Map<String, dynamic> json) {
    return SettingsV1(
      language: json['language'] as String,
      theme: json['theme'] as String,
      fontScale: (json['fontScale'] as num).toDouble(),
      notification: NotificationSetting.fromJson(
        json['notification'] as Map<String, dynamic>,
      ),
      displayBalanceOnHome: json['displayBalanceOnHome'] as bool? ?? false,
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
}
