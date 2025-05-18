class SpendingScreenState {
  final bool isLoading;
  final String error;
  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime calendarSelectedDate;
  final DateTime weeklySpendingCalendarDisplayWeek;

  SpendingScreenState({
    this.isLoading = false,
    this.error = '',
    required this.selectedDate,
    required this.calendarSelectedDate,
    required this.displayedMonth,
    required this.weeklySpendingCalendarDisplayWeek,
  });

  SpendingScreenState copyWith({
    bool? isLoading,
    String? error,
    DateTime? displayedMonth,
    DateTime? selectedDate,
    DateTime? calendarSelectedDate,
    DateTime? weeklySpendingCalendarDisplayWeek,
  }) {
    return SpendingScreenState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      displayedMonth: displayedMonth ?? this.displayedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      calendarSelectedDate: calendarSelectedDate ?? this.calendarSelectedDate,
      weeklySpendingCalendarDisplayWeek:
          weeklySpendingCalendarDisplayWeek ??
          this.weeklySpendingCalendarDisplayWeek,
    );
  }

  factory SpendingScreenState.initial() => SpendingScreenState(
    displayedMonth: DateTime.now(),
    selectedDate: DateTime.now(),
    calendarSelectedDate: DateTime.now(),
    // Set the initial week to the current week starting from Monday
    weeklySpendingCalendarDisplayWeek: DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - DateTime.monday),
    ),
  );
}
