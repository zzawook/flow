class AccountDetailScreenState {
  final bool isLoadingMore;
  final bool hasMore;
  final String? currentAccountNumber;

  AccountDetailScreenState({
    required this.isLoadingMore,
    required this.hasMore,
    this.currentAccountNumber,
  });

  factory AccountDetailScreenState.initial() {
    return AccountDetailScreenState(
      isLoadingMore: false,
      hasMore: true,
      currentAccountNumber: null,
    );
  }

  AccountDetailScreenState copyWith({
    bool? isLoadingMore,
    bool? hasMore,
    String? currentAccountNumber,
  }) {
    return AccountDetailScreenState(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentAccountNumber: currentAccountNumber ?? this.currentAccountNumber,
    );
  }
}
