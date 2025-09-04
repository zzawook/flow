import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';

TransactionState transactionReducer(
  TransactionState prevState,
  dynamic action,
) {
  if (action is DeleteUserAction || action is ClearTransactionStateAction) {
    return TransactionState.initial();
  }
  if (action is SetTransactionStateAction) {
    return action.transactionHistoryState;
  }
  if (action is AddTransaction) {
    // Add only new transactions that do not exist in the previous state
    List<Transaction> updatedTransactions = List.from(prevState.transactions)
      ..addAll(
        action.transactions.where((tx) => !prevState.transactions.contains(tx)),
      );
    return prevState.copyWith(transactions: updatedTransactions);
  }
  return prevState;
}
