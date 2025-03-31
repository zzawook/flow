import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';

SpendingScreenState spendingScreenReducer(
  SpendingScreenState state,
  dynamic action,
) {
  if (action is DecrementDisplayedMonthAction) {
    if (state.displayedMonth.month == DateTime.january) {
      return state.copyWith(
        displayedMonth: DateTime(
          state.displayedMonth.year - 1,
          DateTime.december,
        ),
      );
    }
    return state.copyWith(
      displayedMonth: DateTime(
        state.displayedMonth.year,
        state.displayedMonth.month - 1,
      ),
    );
  } else if (action is IncrementDisplayedMonthAction) {
    if (state.displayedMonth.month == DateTime.now().month &&
        state.displayedMonth.year == DateTime.now().year) {
      return state;
    }
    if (state.displayedMonth.month == DateTime.december) {
      return state.copyWith(
        displayedMonth: DateTime(
          state.displayedMonth.year + 1,
          DateTime.january,
        ),
      );
    }
    return state.copyWith(
      displayedMonth: DateTime(
        state.displayedMonth.year,
        state.displayedMonth.month + 1,
      ),
    );
  }
  return state;
}
