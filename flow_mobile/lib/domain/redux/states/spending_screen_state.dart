/// Helper class to store spending median data for a specific month
class SpendingMedianData {
  final String ageGroup;
  final double medianSpending;
  final int year;
  final int month;
  final int userCount;
  final DateTime calculatedAt;

  SpendingMedianData({
    required this.ageGroup,
    required this.medianSpending,
    required this.year,
    required this.month,
    required this.userCount,
    required this.calculatedAt,
  });

  /// Format age group from "20s" to "Ages 20-29"
  String get formattedAgeGroup {
    final numStr = ageGroup.replaceAll('s', '');
    final num = int.tryParse(numStr) ?? 0;
    final endAge = num + 9;
    return 'Ages $num-$endAge';
  }
}

class SpendingScreenState {
  final bool isLoading;
  final String error;
  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime calendarSelectedDate;
  final DateTime weeklySpendingCalendarDisplayWeek;
  
  // Spending median data
  final Map<String, SpendingMedianData> mediansByMonth; // key: "YYYY-MM"
  final bool isLoadingMedian;
  final String? medianError;

  SpendingScreenState({
    this.isLoading = false,
    this.error = '',
    required this.selectedDate,
    required this.calendarSelectedDate,
    required this.displayedMonth,
    required this.weeklySpendingCalendarDisplayWeek,
    this.mediansByMonth = const {},
    this.isLoadingMedian = false,
    this.medianError,
  });

  SpendingScreenState copyWith({
    bool? isLoading,
    String? error,
    DateTime? displayedMonth,
    DateTime? selectedDate,
    DateTime? calendarSelectedDate,
    DateTime? weeklySpendingCalendarDisplayWeek,
    Map<String, SpendingMedianData>? mediansByMonth,
    bool? isLoadingMedian,
    String? medianError,
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
      mediansByMonth: mediansByMonth ?? this.mediansByMonth,
      isLoadingMedian: isLoadingMedian ?? this.isLoadingMedian,
      medianError: medianError,
    );
  }

  /// Get median data for a specific month, returns null if not cached
  SpendingMedianData? getMedianForMonth(DateTime month) {
    final key = SpendingScreenState.monthKey(month);
    return mediansByMonth[key];
  }

  /// Check if median data exists for a month
  bool hasMedianForMonth(DateTime month) {
    return mediansByMonth.containsKey(SpendingScreenState.monthKey(month));
  }

  /// Generate month key in format "YYYY-MM"
  static String monthKey(DateTime month) {
    return '${month.year}-${month.month.toString().padLeft(2, '0')}';
  }

  factory SpendingScreenState.initial() => SpendingScreenState(
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
