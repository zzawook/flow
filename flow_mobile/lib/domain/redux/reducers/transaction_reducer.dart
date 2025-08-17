import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';

TransactionState transactionReducer(
  TransactionState prevState,
  dynamic action,
) {
  if (action is DeleteUserAction) {
    return TransactionState.initial();
  }
  return prevState;
}
