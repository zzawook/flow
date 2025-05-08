import 'package:flow_mobile/domain/redux/actions/spending_category_screen_actions.dart';
import 'package:flow_mobile/domain/redux/states/spending_category_screen_state.dart';

SpendingCategoryScreenState spendingCategoryScreenReducer(
    SpendingCategoryScreenState state,
    dynamic action,
) {
  if (action is SetSpendingCategoryScreenDisplayMonthAction) {
    return state.copyWith(
      displayedMonth: action.displayMonth,
    );
  }
  return state;
}