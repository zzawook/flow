class SpendingCategoryScreenState {
  final DateTime displayedMonth;

  SpendingCategoryScreenState({required this.displayedMonth});

  factory SpendingCategoryScreenState.initial() {
    return SpendingCategoryScreenState(
      displayedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    );
  }

  SpendingCategoryScreenState copyWith({DateTime? displayedMonth}) {
    return SpendingCategoryScreenState(
      displayedMonth: displayedMonth ?? this.displayedMonth,
    );
  }
}
