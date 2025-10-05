class AssetScreenState {
  final Map<DateTime, double> monthlyAssets;
  final bool isLoading;
  final String? error;

  AssetScreenState({
    this.monthlyAssets = const {},
    this.isLoading = false,
    this.error,
  });

  factory AssetScreenState.initial() => AssetScreenState();

  AssetScreenState copyWith({
    Map<DateTime, double>? monthlyAssets,
    bool? isLoading,
    String? error,
  }) {
    return AssetScreenState(
      monthlyAssets: monthlyAssets ?? this.monthlyAssets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get hasData => monthlyAssets.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetScreenState &&
          runtimeType == other.runtimeType &&
          monthlyAssets == other.monthlyAssets &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode =>
      monthlyAssets.hashCode ^ isLoading.hashCode ^ error.hashCode;
}

