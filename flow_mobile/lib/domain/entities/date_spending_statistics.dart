import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_spending_statistics.freezed.dart';
part 'date_spending_statistics.g.dart';

@freezed
class DateSpendingStatistics with _$DateSpendingStatistics {
  const factory DateSpendingStatistics({
    required double income,
    required double expense,
    required DateTime date,
  }) = _DateSpendingStatistics;

  factory DateSpendingStatistics.fromJson(Map<String, dynamic> json) => _$DateSpendingStatisticsFromJson(json);
}