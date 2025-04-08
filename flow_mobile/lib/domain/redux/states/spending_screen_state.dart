class SpendingScreenState {
  final bool isLoading;
  final String error;
  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime calendarSelectedDate;

  SpendingScreenState({
    this.isLoading = false,
    this.error = '',
    required this.selectedDate,
    required this.calendarSelectedDate,
    required this.displayedMonth,
  });

  SpendingScreenState copyWith({
    bool? isLoading,
    String? error,
    DateTime? displayedMonth,
    DateTime? selectedDate,
    DateTime? calendarSelectedDate,
  }) {
    return SpendingScreenState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      displayedMonth: displayedMonth ?? this.displayedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      calendarSelectedDate: calendarSelectedDate ?? this.calendarSelectedDate,
    );
  }

  factory SpendingScreenState.initial() => SpendingScreenState(
    displayedMonth: DateTime.now(),
    selectedDate: DateTime.now(),
    calendarSelectedDate: DateTime.now(),
  );
}
