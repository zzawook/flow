class SetAccountDetailLoadingAction {
  final bool isLoadingMore;
  final String accountNumber;

  SetAccountDetailLoadingAction({
    required this.isLoadingMore,
    required this.accountNumber,
  });
}

class SetAccountDetailHasMoreAction {
  final bool hasMore;
  final String accountNumber;

  SetAccountDetailHasMoreAction({
    required this.hasMore,
    required this.accountNumber,
  });
}

class ResetAccountDetailStateAction {}
