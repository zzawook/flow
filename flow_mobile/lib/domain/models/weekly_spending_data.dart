import 'package:flow_mobile/domain/entities/transaction.dart';

class WeeklySpendingData {
  late Map<DateTime, Map<String, double>> weeklySpendingData;

  WeeklySpendingData(DateTime displayedWeek) {
    weeklySpendingData = {
      for (var date in List.generate(7, (index) {
        DateTime date = DateTime(
          displayedWeek.year,
          displayedWeek.month,
          displayedWeek.day + index,
        );
        return date;
      }))
        date: {'income': 0.0, 'expense': 0.0},
    };
  }

  void addTransaction(Transaction transaction) {
    DateTime transactionDate = transaction.date;
    if (weeklySpendingData.containsKey(transactionDate)) {
      if (transaction.amount > 0) {
        weeklySpendingData[transactionDate]!['income'] =
            (weeklySpendingData[transactionDate]!['income'] ?? 0.0) +
            transaction.amount;
      } else {
        weeklySpendingData[transactionDate]!['expense'] =
            (weeklySpendingData[transactionDate]!['expense'] ?? 0.0) +
            transaction.amount;
      }
    }
  }

  Map<DateTime, Map<String, double>> getWeeklySpendingData() {
    return weeklySpendingData;
  }
}
