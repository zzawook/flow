// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      language: json['language'] as String,
      theme: json['theme'] as String,
      fontScale: (json['fontScale'] as num).toDouble(),
      notification: json['notification'] as bool,
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'theme': instance.theme,
      'fontScale': instance.fontScale,
      'notification': instance.notification,
    };
