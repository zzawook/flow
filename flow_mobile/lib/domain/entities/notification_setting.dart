import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_setting.freezed.dart';
part 'notification_setting.g.dart';

@freezed
class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required bool masterEnabled,
    required bool insightNotificationEnabled,
    required bool periodicNotificationEnabled,
    required bool periodicNotificationAutoEnabled,
    required List<String> periodicNotificationCron,
  }) = _NotificationSetting;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) => _$NotificationSettingFromJson(json);

  factory NotificationSetting.initial() {
    return const NotificationSetting(
      masterEnabled: true,
      insightNotificationEnabled: true,
      periodicNotificationEnabled: true,
      periodicNotificationAutoEnabled: true,
      // Default to weekly at every Sunday at 9 PM
      periodicNotificationCron: ['0 21 * * 0'],
    );
  }
}