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