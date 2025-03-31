import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';

class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String error;

  TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.error = '',
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  factory TransactionState.initial() => TransactionState();

  DateSpendingStatistics getTransactionStatisticForDate(DateTime date) {
    final transactionsForDate =
        transactions.where((transaction) {
          final transactionDate = transaction.date;
          return transactionDate.year == date.year &&
              transactionDate.month == date.month &&
              transactionDate.day == date.day;
        }).toList();

    final totalIncome = transactionsForDate
        .where((transaction) => transaction.amount > 0)
        .fold(0.0, (previousValue, element) => previousValue + element.amount);

    final totalExpense = transactionsForDate
        .where((transaction) => transaction.amount < 0)
        .fold(0.0, (previousValue, element) => previousValue + element.amount);

    return DateSpendingStatistics(
      date: date,
      income: totalIncome,
      expense: totalExpense,
    );
  }

  double getBalanceInCentsForMonth(DateTime month) {
    final transactionsForMonth =
        transactions.where((transaction) {
          final transactionDate = transaction.date;
          return transactionDate.year == month.year &&
              transactionDate.month == month.month;
        }).toList();

    return transactionsForMonth.fold(0.0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  double getIncomeInCentsForMonth(DateTime month) {
    final transactionsForMonth =
        transactions.where((transaction) {
          final transactionDate = transaction.date;
          return transactionDate.year == month.year &&
              transactionDate.month == month.month &&
              transaction.amount > 0;
        }).toList();

    return transactionsForMonth.fold(0.0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  double getExpenseInCentsForMonth(DateTime month) {
    final transactionsForMonth =
        transactions.where((transaction) {
          final transactionDate = transaction.date;
          return transactionDate.year == month.year &&
              transactionDate.month == month.month &&
              transaction.amount < 0;
        }).toList();

    return transactionsForMonth.fold(0.0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  List<Transaction> getTransactionsForMonth(DateTime displayedMonth) {
    return transactions.where((transaction) {
      final transactionDate = transaction.date;
      return transactionDate.year == displayedMonth.year &&
          transactionDate.month == displayedMonth.month;
    }).toList();
  }
}
