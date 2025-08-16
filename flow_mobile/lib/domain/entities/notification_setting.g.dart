// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingImpl _$$NotificationSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingImpl(
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

Map<String, dynamic> _$$NotificationSettingImplToJson(
        _$NotificationSettingImpl instance) =>
    <String, dynamic>{
      'masterEnabled': instance.masterEnabled,
      'insightNotificationEnabled': instance.insightNotificationEnabled,
      'periodicNotificationEnabled': instance.periodicNotificationEnabled,
      'periodicNotificationAutoEnabled':
          instance.periodicNotificationAutoEnabled,
      'periodicNotificationCron': instance.periodicNotificationCron,
    };
