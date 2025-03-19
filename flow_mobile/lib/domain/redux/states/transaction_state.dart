import 'package:flow_mobile/domain/entities/transaction.dart';

class TransactionState {
  final List<Transaction> transactions;
  final double balance;

  TransactionState({required this.transactions, required this.balance});

  factory TransactionState.initial() => TransactionState(transactions: [], balance: 0.0);
}

// Action
class AddTransactionAction {
  final Transaction transaction;
  AddTransactionAction(this.transaction);
}

