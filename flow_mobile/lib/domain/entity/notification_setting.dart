import 'package:hive_flutter/adapters.dart';

part 'notification_setting.g.dart';

@HiveType(typeId: 6)
class NotificationSetting {
  @HiveField(0)
  final bool masterEnabled;

  @HiveField(1)
  final bool insightNotificationEnabled;

  @HiveField(2)
  final bool periodicNotificationEnabled;

  @HiveField(3)
  final bool periodicNotificationAutoEnabled;

  @HiveField(4)
  final List<String> periodicNotificationCron;

  NotificationSetting({
    required this.masterEnabled,
    required this.insightNotificationEnabled,
    required this.periodicNotificationEnabled,
    required this.periodicNotificationAutoEnabled,
    required this.periodicNotificationCron,
  });

  NotificationSetting copyWith({
    bool? masterEnabled,
    bool? insightNotificationEnabled,
    bool? periodicNotificationEnabled,
    bool? periodicNotificationAutoEnabled,
    List<String>? periodicNotificationCron,
  }) {
    return NotificationSetting(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      insightNotificationEnabled:
          insightNotificationEnabled ?? this.insightNotificationEnabled,
      periodicNotificationEnabled:
          periodicNotificationEnabled ?? this.periodicNotificationEnabled,
      periodicNotificationCron:
          periodicNotificationCron ?? this.periodicNotificationCron,
      periodicNotificationAutoEnabled:
          periodicNotificationAutoEnabled ??
          this.periodicNotificationAutoEnabled,
    );
  }

  factory NotificationSetting.fromJson(Map<String, dynamic> json) {
    return NotificationSetting(
      masterEnabled: json['masterEnabled'] as bool,
      insightNotificationEnabled: json['insightNotificationEnabled'] as bool,
      periodicNotificationEnabled: json['periodicNotificationEnabled'] as bool,
      periodicNotificationAutoEnabled:
          json['periodicNotificationAutoEnabled'] as bool,
      periodicNotificationCron:
          (json['periodicNotificationCron'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );
  }

  factory NotificationSetting.initial() {
    return NotificationSetting(
      masterEnabled: true,
      insightNotificationEnabled: true,
      periodicNotificationEnabled: true,
      periodicNotificationAutoEnabled: true,
      // Default to weekly at every Sunday at 9 PM
      periodicNotificationCron: ['0 21 * * 0'],
    );
  }
}
