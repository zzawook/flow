class SetMonthlyAssetsAction {
  final Map<DateTime, double> monthlyAssets;

  SetMonthlyAssetsAction(this.monthlyAssets);
}

class SetMonthlyAssetsLoadingAction {
  final bool isLoading;

  SetMonthlyAssetsLoadingAction(this.isLoading);
}

class SetMonthlyAssetsErrorAction {
  final String error;

  SetMonthlyAssetsErrorAction(this.error);
}

class ClearMonthlyAssetsErrorAction {}

