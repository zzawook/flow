import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/core/errors/errors.dart';

part 'transaction_state_model.freezed.dart';

@freezed
class TransactionStateModel with _$TransactionStateModel, BaseStateMixin {
  const factory TransactionStateModel({
    @Default([]) List<Transaction> transactions,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _TransactionStateModel;

  const TransactionStateModel._();

  factory TransactionStateModel.initial() => const TransactionStateModel();
}

// Extension methods to mirror the existing Redux state functionality
extension TransactionStateModelExtensions on TransactionStateModel {
  DateSpendingStatistics getTransactionStatisticForDate(DateTime date) {
    final transactionsForDate = transactions.where((transaction) {
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

  double getBalanceForMonth(DateTime month) {
    final transactionsForMonth = transactions.where((transaction) {
      final transactionDate = transaction.date;
      return transactionDate.year == month.year &&
          transactionDate.month == month.month;
    }).toList();

    return transactionsForMonth.fold(0.0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  double getIncomeForMonth(DateTime month) {
    final transactionsForMonth = transactions.where((transaction) {
      final transactionDate = transaction.date;
      return transactionDate.year == month.year &&
          transactionDate.month == month.month &&
          transaction.amount > 0;
    }).toList();

    return transactionsForMonth.fold(0.0, (previousValue, element) {
      return previousValue + element.amount;
    });
  }

  double getExpenseForMonth(DateTime month) {
    final transactionsForMonth = transactions.where((transaction) {
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

  double getMonthlySpendingDifference() {
    final currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);

    final currentMonthSpending = getExpenseForMonth(currentMonth);
    final previousMonthSpending = getExpenseForMonth(previousMonth);

    return currentMonthSpending - previousMonthSpending;
  }

  List<Transaction> getTransactionsFromTo(DateTime from, DateTime to) {
    return transactions.where((transaction) {
      return (DateTimeUtil.isSameDate(transaction.date, from) ||
              DateTimeUtil.isSameDate(transaction.date, to)) ||
          transaction.date.isAfter(from) && transaction.date.isBefore(to);
    }).toList();
  }

  List<Transaction> getTransactionsByAccount(BankAccount bankAccount) {
    return transactions.where((transaction) {
      return transaction.bankAccount.accountNumber == bankAccount.accountNumber;
    }).toList();
  }

  List<Transaction> getTransactionByCategoryFromTo(
    String category,
    DateTime dateTime,
    DateTime dateTime2,
  ) {
    return transactions.where((transaction) {
      return transaction.category == category &&
          ((DateTimeUtil.isSameDate(transaction.date, dateTime) ||
                  DateTimeUtil.isSameDate(transaction.date, dateTime2)) ||
              transaction.date.isAfter(dateTime) &&
                  transaction.date.isBefore(dateTime2));
    }).toList();
  }
}