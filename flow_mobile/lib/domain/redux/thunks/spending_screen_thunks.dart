import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> setDisplayedMonthThunk(DateTime month) {
  return (Store<FlowState> store) async {
    final transactionManager = getIt<TransactionManager>();
    // if month is older than 11 months from current month
    if (month.isBefore(
      DateTime(
        DateTime.now().year,
        DateTime.now().month - 11,
        DateTime.now().day,
      ),
    )) {
      List<Transaction> transactions = await transactionManager
          .fetchPastOverYearTransactionsAroundFromRemote(month);
      store.dispatch(AddTransaction(transactions));
    }

    store.dispatch(SetDisplayedMonthAction(month));
  };
}

ThunkAction<FlowState> incrementDisplayedMonthThunk() {
  return (Store<FlowState> store) async {
    DateTime currentDisplayedMonth =
        store.state.screenState.spendingScreenState.displayedMonth;
    DateTime newDisplayedMonth = DateTime(
      currentDisplayedMonth.year,
      currentDisplayedMonth.month + 1,
      currentDisplayedMonth.day,
    );
    store.dispatch(setDisplayedMonthThunk(newDisplayedMonth));
  };
}

ThunkAction<FlowState> decrementDisplayedMonthThunk() {
  return (Store<FlowState> store) async {
    DateTime currentDisplayedMonth =
        store.state.screenState.spendingScreenState.displayedMonth;
    DateTime newDisplayedMonth = DateTime(
      currentDisplayedMonth.year,
      currentDisplayedMonth.month - 1,
      currentDisplayedMonth.day,
    );
    store.dispatch(setDisplayedMonthThunk(newDisplayedMonth));
  };
}
