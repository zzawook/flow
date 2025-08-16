// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      bankAccount:
          _bankAccountFromJson(json['bankAccount'] as Map<String, dynamic>),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      method: json['method'] as String,
      note: json['note'] as String,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'bankAccount': _bankAccountToJson(instance.bankAccount),
      'category': instance.category,
      'date': instance.date.toIso8601String(),
      'method': instance.method,
      'note': instance.note,
    };
