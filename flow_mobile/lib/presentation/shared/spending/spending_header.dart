import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';
import 'package:flow_mobile/presentation/shared/spending/spending_monthly_trend_line_graph.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingHeader extends ConsumerWidget {
  const SpendingHeader({
    super.key,
    required this.displayMonthYear,
    required this.weeklySpendingCalendarDisplayWeek,
  });

  final DateTime displayMonthYear;
  final DateTime weeklySpendingCalendarDisplayWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionStateProvider);
    final spendingScreenNotifier = ref.read(spendingScreenNotifierProvider.notifier);
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonthSelector(
                displayMonthYear: displayMonthYear,
                displayMonthYearSetter: (date) {
                  spendingScreenNotifier.updateDisplayedMonth(date);
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  () {
                    var balance = transactionState.getExpenseForMonth(displayMonthYear).abs();
                    return '\$ ${balance.toStringAsFixed(2)}';
                  }(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C864),
                  ),
                ),
              ),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final transactionState = ref.watch(transactionStateProvider);
            
            DateTime currentMonth = DateTime(
              DateTime.now().year,
              DateTime.now().month,
            );

            List<Transaction> currentMonthTransactions = transactionState
                .getTransactionsForMonth(currentMonth);
            List<Transaction> lastMonthTransactions = transactionState
                .getTransactionsForMonth(
                  DateTime(currentMonth.year, currentMonth.month - 1),
                );

            List<double> currentMonthSpendingByDays = [];
            List<double> lastMonthSpendingByDays = [];

            double currentMonthSpendingCumSum = 0;
            double lastMonthSpendingCumSum = 0;
            // For each day in current month, find sum of all transactions on that day from each transaction list, and calculate the cumulative spending until that day
            for (
              int i = 1;
              i <= DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
              i++
            ) {
              DateTime date = DateTime(
                currentMonth.year,
                currentMonth.month,
                i,
              );
              // Check if the date is in the future
              if (date.isAfter(DateTime.now())) {
                continue;
              }
              double todaySpending = 0;
              currentMonthTransactions
                  .where(
                    (transaction) =>
                        DateTimeUtil.isSameDate(transaction.date, date) &&
                        transaction.amount < 0,
                  )
                  .forEach((transaction) {
                    todaySpending += transaction.amount.abs();
                  });
              currentMonthSpendingCumSum += todaySpending;
              currentMonthSpendingByDays.add(currentMonthSpendingCumSum);
            }

            // For each day in last month, find sum of all transactions on that day from each transaction list, and calculate the cumulative spending until that day
            for (
              int i = 1;
              i <= DateTime(currentMonth.year, currentMonth.month, 0).day;
              i++
            ) {
              DateTime date = DateTime(
                currentMonth.year,
                currentMonth.month - 1,
                i,
              );
              double todaySpending = 0;
              lastMonthTransactions
                  .where(
                    (transaction) =>
                        DateTimeUtil.isSameDate(transaction.date, date) &&
                        transaction.amount < 0,
                  )
                  .forEach((transaction) {
                    todaySpending += transaction.amount.abs();
                  });
              lastMonthSpendingCumSum += todaySpending;
              lastMonthSpendingByDays.add(lastMonthSpendingCumSum);
            }

            return SpendingMonthlyTrendLineGraph(
              currentMonthSpendingByDays: currentMonthSpendingByDays,
              lastMonthSpendingByDays: lastMonthSpendingByDays,
              width: 180,
              height: 85,
              enableTooltip: false,
            );
          },
        ),
      ],
    );
  }
}
