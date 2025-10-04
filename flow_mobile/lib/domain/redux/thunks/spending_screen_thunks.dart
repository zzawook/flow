import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
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

    // Fetch spending median for the new month
    store.dispatch(fetchSpendingMedianThunk(month));
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

/// Fetch spending median for a specific month
/// Only fetches if data is not already cached
ThunkAction<FlowState> fetchSpendingMedianThunk(DateTime month) {
  return (Store<FlowState> store) async {
    print("Fetching spending median for month: $month");
    final monthKey = SpendingScreenState.monthKey(month);
    final spendingScreenState = store.state.screenState.spendingScreenState;

    // Check if already cached
    if (spendingScreenState.hasMedianForMonth(month)) {
      return; // Already have data, no need to fetch
    }

    // Check if already loading
    if (spendingScreenState.isLoadingMedian) {
      return; // Already fetching
    }

    // Set loading state
    store.dispatch(SetSpendingMedianLoadingAction(true));

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getSpendingMedianForAgeGroup(
        year: month.year,
        month: month.month,
      );

      // Dispatch success action with the data
      store.dispatch(
        SetSpendingMedianAction(
          monthKey: monthKey,
          ageGroup: response.ageGroup,
          medianSpending: response.medianSpending,
          year: response.year,
          month: response.month,
          userCount: response.userCount,
          calculatedAt: response.calculatedAt.toDateTime(),
        ),
      );
    } catch (error) {
      // Dispatch error action
      String errorMessage = 'Not enough data for comparison';

      // Check for specific error types
      if (error.toString().contains('NOT_FOUND')) {
        errorMessage = 'No data available for your age group this month';
      } else if (error.toString().contains('FAILED_PRECONDITION')) {
        errorMessage = 'Please update your date of birth in settings';
      } else if (error.toString().contains('UNAUTHENTICATED')) {
        errorMessage = 'Please log in again';
      }

      store.dispatch(SetSpendingMedianErrorAction(errorMessage));
    }
  };
}
