import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/reducers/refresh_screen_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/spending_screen_reducer.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';

ScreenState screenReducer(ScreenState state, dynamic action) {
  if (action is NavigateToScreenAction) {
    return state.copyWith(
      screenName: action.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: false,
      refreshScreenState: state.refreshScreenState,
    );
  }
  if (action is InitiateRefreshAction) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: true,
      refreshScreenState: state.refreshScreenState,
    );
  }
  if (action is IncrementDisplayedMonthAction ||
      action is DecrementDisplayedMonthAction) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: spendingScreenReducer(
        state.spendingScreenState,
        action,
      ),
      isRefreshing: state.isRefreshing,
      refreshScreenState: state.refreshScreenState,
    );
  }
  if (action is InitSelectedBankAction || action is SelectBankAction) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: state.isRefreshing,
      refreshScreenState: refreshScreenReducer(
        state.refreshScreenState,
        action,
      ),
    );
  }
  return state;
}
