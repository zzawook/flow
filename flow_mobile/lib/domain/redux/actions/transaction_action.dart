import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';

class SetTransactionStateAction {
  final TransactionState transactionHistoryState;

  SetTransactionStateAction({required this.transactionHistoryState});
}

class AddTransaction {
  final List<Transaction> transactions;

  AddTransaction(this.transactions);
}

class SetTransactionCategoryAction {
  final Transaction transaction;
  final String category;

  SetTransactionCategoryAction({
    required this.transaction,
    required this.category,
  });
}

class ToggleTransactionIncludeInSpendingOrIncomeAction {
  final Transaction transaction;

  ToggleTransactionIncludeInSpendingOrIncomeAction({required this.transaction});
}

class ClearTransactionStateAction {}
