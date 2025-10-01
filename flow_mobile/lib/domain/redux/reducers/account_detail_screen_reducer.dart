import 'package:flow_mobile/domain/redux/actions/account_detail_screen_actions.dart';
import 'package:flow_mobile/domain/redux/states/account_detail_screen_state.dart';

AccountDetailScreenState accountDetailScreenReducer(
  AccountDetailScreenState state,
  dynamic action,
) {
  if (action is SetAccountDetailLoadingAction) {
    return state.copyWith(
      isLoadingMore: action.isLoadingMore,
      currentAccountNumber: action.accountNumber,
    );
  }
  if (action is SetAccountDetailHasMoreAction) {
    return state.copyWith(
      hasMore: action.hasMore,
      currentAccountNumber: action.accountNumber,
    );
  }
  if (action is ResetAccountDetailStateAction) {
    return AccountDetailScreenState.initial();
  }
  return state;
}
