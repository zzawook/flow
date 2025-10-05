import 'package:flow_mobile/domain/redux/actions/asset_screen_actions.dart';
import 'package:flow_mobile/domain/redux/states/asset_screen_state.dart';

AssetScreenState assetScreenReducer(AssetScreenState state, dynamic action) {
  if (action is SetMonthlyAssetsAction) {
    return state.copyWith(
      monthlyAssets: action.monthlyAssets,
      isLoading: false,
      error: null,
    );
  }

  if (action is SetMonthlyAssetsLoadingAction) {
    return state.copyWith(isLoading: action.isLoading);
  }

  if (action is SetMonthlyAssetsErrorAction) {
    return state.copyWith(error: action.error, isLoading: false);
  }

  if (action is ClearMonthlyAssetsErrorAction) {
    return state.copyWith(error: null);
  }

  return state;
}

