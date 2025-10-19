import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/redux/actions/account_detail_screen_actions.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> getAccountTransactionsThunk({
  required BankAccount account,
  String? oldestTransactionId,
  int limit = 20,
}) {
  return (Store<FlowState> store) async {
    final transactionManager = getIt<TransactionManager>();

    // Set loading state
    store.dispatch(
      SetAccountDetailLoadingAction(
        isLoadingMore: true,
        accountNumber: account.accountNumber,
      ),
    );

    try {
      final transactions = await transactionManager.getTransactionForAccount(
        account,
        limit,
        oldestTransactionId: oldestTransactionId,
      );

      // Add transactions to state (reducer handles deduplication)
      store.dispatch(AddTransaction(transactions));

      // Update hasMore flag based on response
      store.dispatch(
        SetAccountDetailHasMoreAction(
          hasMore: transactions.length >= limit,
          accountNumber: account.accountNumber,
        ),
      );
    } catch (error) {
      // On error, set hasMore to false to prevent further attempts
      store.dispatch(
        SetAccountDetailHasMoreAction(
          hasMore: false,
          accountNumber: account.accountNumber,
        ),
      );
    } finally {
      // Clear loading state
      store.dispatch(
        SetAccountDetailLoadingAction(
          isLoadingMore: false,
          accountNumber: account.accountNumber,
        ),
      );
    }
  };
}
