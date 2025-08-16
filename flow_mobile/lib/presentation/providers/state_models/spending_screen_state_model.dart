import 'package:freezed_annotation/freezed_annotation.dart';

part 'spending_screen_state_model.freezed.dart';

@freezed
class SpendingScreenStateModel with _$SpendingScreenStateModel {
  const factory SpendingScreenStateModel({
    @Default(false) bool isLoading,
    @Default('') String error,
    required DateTime selectedDate,
    required DateTime calendarSelectedDate,
    required DateTime displayedMonth,
    required DateTime weeklySpendingCalendarDisplayWeek,
  }) = _SpendingScreenStateModel;

  factory SpendingScreenStateModel.initial() => SpendingScreenStateModel(
    displayedMonth: DateTime.now(),
    selectedDate: DateTime.now(),
    calendarSelectedDate: DateTime.now(),
    // Set the initial week to the current week starting from Monday
    weeklySpendingCalendarDisplayWeek: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).subtract(
      Duration(days: DateTime.now().weekday - DateTime.monday),
    ),
  );
}