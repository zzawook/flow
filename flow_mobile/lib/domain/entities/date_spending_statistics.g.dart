// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_spending_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DateSpendingStatisticsImpl _$$DateSpendingStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$DateSpendingStatisticsImpl(
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$DateSpendingStatisticsImplToJson(
        _$DateSpendingStatisticsImpl instance) =>
    <String, dynamic>{
      'income': instance.income,
      'expense': instance.expense,
      'date': instance.date.toIso8601String(),
    };
