// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankAccountImpl _$$BankAccountImplFromJson(Map<String, dynamic> json) =>
    _$BankAccountImpl(
      accountNumber: json['accountNumber'] as String,
      accountHolder: json['accountHolder'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      accountName: json['accountName'] as String,
      bank: _bankFromJson(json['bank'] as Map<String, dynamic>),
      transferCount: (json['transferCount'] as num).toInt(),
      isHidden: json['isHidden'] as bool? ?? false,
    );

Map<String, dynamic> _$$BankAccountImplToJson(_$BankAccountImpl instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'accountHolder': instance.accountHolder,
      'balance': instance.balance,
      'accountName': instance.accountName,
      'bank': _bankToJson(instance.bank),
      'transferCount': instance.transferCount,
      'isHidden': instance.isHidden,
    };
