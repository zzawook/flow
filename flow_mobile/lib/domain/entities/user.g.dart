// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      name: json['name'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      phoneNumber: json['phoneNumber'] as String,
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'nickname': instance.nickname,
    };
