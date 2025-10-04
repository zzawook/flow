class DecrementDisplayedMonthAction {
  DecrementDisplayedMonthAction();
}

class IncrementDisplayedMonthAction {
  IncrementDisplayedMonthAction();
}

class SetDisplayedMonthAction {
  final DateTime displayMonthYear;

  SetDisplayedMonthAction(this.displayMonthYear);
}

class SetSelectedDateAction {
  final DateTime selectedDate;

  SetSelectedDateAction(this.selectedDate);
}

class SetCalendarSelectedDateAction {
  final DateTime calendarSelectedDate;

  SetCalendarSelectedDateAction(this.calendarSelectedDate);
}

class SetWeeklySpendingCalendarDisplayWeekAction {
  final DateTime weeklySpendingCalendarDisplayWeek;

  SetWeeklySpendingCalendarDisplayWeekAction(this.weeklySpendingCalendarDisplayWeek);
}

// Spending Median Actions

class FetchSpendingMedianAction {
  final DateTime month;

  FetchSpendingMedianAction(this.month);
}

class SetSpendingMedianLoadingAction {
  final bool isLoading;

  SetSpendingMedianLoadingAction(this.isLoading);
}

class SetSpendingMedianAction {
  final String monthKey;
  final String ageGroup;
  final double medianSpending;
  final int year;
  final int month;
  final int userCount;
  final DateTime calculatedAt;

  SetSpendingMedianAction({
    required this.monthKey,
    required this.ageGroup,
    required this.medianSpending,
    required this.year,
    required this.month,
    required this.userCount,
    required this.calculatedAt,
  });
}

class SetSpendingMedianErrorAction {
  final String? error;

  SetSpendingMedianErrorAction(this.error);
}
