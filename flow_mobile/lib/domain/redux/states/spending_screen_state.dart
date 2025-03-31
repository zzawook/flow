class SpendingScreenState {
  final bool isLoading;
  final String error;
  final DateTime displayedMonth;

  SpendingScreenState({
    this.isLoading = false,
    this.error = '',
    required this.displayedMonth,
  });

  SpendingScreenState copyWith({
    bool? isLoading,
    String? error,
    DateTime? displayedMonth,
  }) {
    return SpendingScreenState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      displayedMonth: displayedMonth ?? this.displayedMonth,
    );
  }

  factory SpendingScreenState.initial() =>
      SpendingScreenState(displayedMonth: DateTime.now());
}
