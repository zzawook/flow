// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paynow_recipient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayNowRecipientImpl _$$PayNowRecipientImplFromJson(
        Map<String, dynamic> json) =>
    _$PayNowRecipientImpl(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      idNumber: json['idNumber'] as String,
      bank: _bankFromJson(json['bank'] as Map<String, dynamic>),
      transferCount: (json['transferCount'] as num).toInt(),
    );

Map<String, dynamic> _$$PayNowRecipientImplToJson(
        _$PayNowRecipientImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'idNumber': instance.idNumber,
      'bank': _bankToJson(instance.bank),
      'transferCount': instance.transferCount,
    };
