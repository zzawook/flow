import 'package:flow_mobile/domain/entities/transaction.dart';

class WeeklySpendingData {
  late Map<DateTime, Map<String, double>> weeklySpendingData;

  WeeklySpendingData() {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    DateTime aWeekAgo = DateTime(
      today.year,
      today.month,
      today.day - 7,
    );

    weeklySpendingData = { for (var date in List.generate(7, (index) {
      DateTime date = DateTime(
          aWeekAgo.year,
          aWeekAgo.month,
          aWeekAgo.day + index + 1,
      );
      return date;
      })) date : {'income': 0.0, 'expense': 0.0} };
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