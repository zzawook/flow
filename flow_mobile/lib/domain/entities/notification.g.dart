// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['imageUrl'] as String?,
      action: json['action'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isChecked: json['isChecked'] as bool? ?? false,
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'imageUrl': instance.imageUrl,
      'action': instance.action,
      'createdAt': instance.createdAt.toIso8601String(),
      'isChecked': instance.isChecked,
    };
