import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/actions/demo_actions.dart';
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
  if (action is SetDemoDataAction) {
    return prevState.copyWith(transactions: action.transactions);
  }
  if (action is ClearDemoDataAction) {
    return prevState.copyWith(transactions: []);
  }
  if (action is SetTransactionStateAction) {
    return action.transactionHistoryState;
  }
  if (action is SetTransactionCategoryAction) {
    List<Transaction> updatedTransactions = prevState.transactions.map((transaction) {
      if (transaction.id == action.transaction.id) {
        return transaction.copyWith(category: action.category);
      }
      return transaction;
    }).toList();
    return prevState.copyWith(transactions: updatedTransactions);
  }

  if (action is ToggleTransactionIncludeInSpendingOrIncomeAction) {
    List<Transaction> updatedTransactions = prevState.transactions.map((transaction) {
      if (transaction.id == action.transaction.id) {
        return transaction.copyWith(
          isIncludedInSpendingOrIncome: !transaction.isIncludedInSpendingOrIncome
        );
      }
      return transaction;
    }).toList();
    return prevState.copyWith(transactions: updatedTransactions);
  }

  if (action is AddTransaction) {
    List<Transaction> updatedTransactions = List.from(prevState.transactions)
      ..addAll(
        action.transactions.where(
          (newTransaction) => !prevState.transactions
              .any((existingTransaction) => existingTransaction.id == newTransaction.id),
        ),
      );

    // Update existing transactions
    for (var newTransaction in action.transactions) {
      int index = updatedTransactions.indexWhere((t) => t.id == newTransaction.id);
      if (index != -1) {
        updatedTransactions[index] = newTransaction;
      }
    }
    return prevState.copyWith(transactions: updatedTransactions);
  }
  return prevState;
}
