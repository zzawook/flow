import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/actions/spending_category_screen_actions.dart';
import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/reducers/refresh_screen_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/spending_category_screen_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/spending_screen_reducer.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';

ScreenState screenReducer(ScreenState state, dynamic action) {
  if (action is NavigateToScreenAction) {
    return state.copyWith(
      screenName: action.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: false,
      refreshScreenState: state.refreshScreenState,
      spendingCategoryScreenState: state.spendingCategoryScreenState,
    );
  }
  if (action is InitiateRefreshAction) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: true,
      refreshScreenState: state.refreshScreenState,
      spendingCategoryScreenState: state.spendingCategoryScreenState,
    );
  }
  if (action is IncrementDisplayedMonthAction ||
      action is DecrementDisplayedMonthAction ||
      action is SetWeeklySpendingCalendarDisplayWeekAction ||
      action is SetDisplayedMonthAction ||
      action is SetSelectedDateAction ||
      action is SetCalendarSelectedDateAction) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: spendingScreenReducer(
        state.spendingScreenState,
        action,
      ),
      isRefreshing: state.isRefreshing,
      refreshScreenState: state.refreshScreenState,
      spendingCategoryScreenState: state.spendingCategoryScreenState,
    );
  }
  if (action is InitSelectedBankAction ||
      action is SelectBankAction ||
      action is StartBankLinkingAction ||
      action is CancelLinkBankingScreenAction ||
      action is BankLinkingSuccessAction ||
      action is RemoveCurrentLinkingBankAction ||
      action is StartBankDataFetchMonitoringAction ||
      action is FinishBankDataFetchMonitoringAction
      ) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: state.isRefreshing,
      spendingCategoryScreenState: state.spendingCategoryScreenState,
      refreshScreenState: refreshScreenReducer(
        state.refreshScreenState,
        action,
      ),
    );
  }
  if (action is SetSpendingCategoryScreenDisplayMonthAction) {
    return state.copyWith(
      screenName: state.screenName,
      spendingScreenState: state.spendingScreenState,
      isRefreshing: state.isRefreshing,
      refreshScreenState: state.refreshScreenState,
      spendingCategoryScreenState: spendingCategoryScreenReducer(
        state.spendingCategoryScreenState,
        action,
      ),
    );
  }
  
  return state;
}
