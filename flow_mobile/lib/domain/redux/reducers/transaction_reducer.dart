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
  return prevState;
}
