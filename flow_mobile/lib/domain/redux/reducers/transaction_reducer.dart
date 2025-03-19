import 'package:flow_mobile/domain/redux/states/transaction_state.dart';

TransactionState transactionReducer(TransactionState state, dynamic action) {
  if (action is AddTransactionAction) {
    return TransactionState(
      transactions: [...state.transactions, action.transaction],
      balance: state.balance + action.transaction.amount,
    );
  }
  return state;
}
