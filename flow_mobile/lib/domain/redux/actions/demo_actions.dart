import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/entity/recurring_spending.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';

/// Action to populate Redux state with demo data
class SetDemoDataAction {
  final List<Transaction> transactions;
  final List<BankAccount> bankAccounts;
  final List<Card> cards;
  final List<RecurringSpending> recurringSpending;
  final bool isDemoMode;

  SetDemoDataAction({
    required this.transactions,
    required this.bankAccounts,
    required this.cards,
    required this.recurringSpending,
    this.isDemoMode = true,
  });
}

/// Action to clear all demo data from Redux state
class ClearDemoDataAction {
  ClearDemoDataAction();
}
