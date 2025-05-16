import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/shared/widgets/spending/spending_monthly_trend_line_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingTrendCard extends StatelessWidget {
  const SpendingTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, TransactionState>(
      converter: (store) {
        return store.state.transactionState;
      },
      builder: (context, transactionState) {
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
          DateTime date = DateTime(currentMonth.year, currentMonth.month, i);
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

        return Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Spent \$ ${currentMonthSpendingByDays.last.toStringAsFixed(2)} this month",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "\$ ${(currentMonthSpendingByDays.last - lastMonthSpendingByDays[currentMonthSpendingByDays.indexOf(currentMonthSpendingByDays.last)]).abs().toStringAsFixed(2)} ${currentMonthSpendingByDays.last > lastMonthSpendingByDays[currentMonthSpendingByDays.indexOf(currentMonthSpendingByDays.last)] ? "more" : "less"}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color:
                              currentMonthSpendingByDays.last >
                                      lastMonthSpendingByDays[currentMonthSpendingByDays
                                          .indexOf(
                                            currentMonthSpendingByDays.last,
                                          )]
                                  ? Colors.red
                                  : Color(0xFF50C878),
                        ),
                      ),
                      Text(
                        " than last month",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0x88000000),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const FlowSeparatorBox(height: 24),

              SpendingMonthlyTrendLineGraph(
                currentMonthSpendingByDays: currentMonthSpendingByDays,
                lastMonthSpendingByDays: lastMonthSpendingByDays,
                width: double.infinity,
                height: 150,
                enableTooltip: true,
              ),

              const FlowSeparatorBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 3,
                    color: const Color(0xFF50C878),
                  ),
                  const FlowSeparatorBox(width: 8),
                  Text(
                    DateTimeUtil.getMonthName(currentMonth.month),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF000000),
                    ),
                  ),

                  const FlowSeparatorBox(width: 40),

                  Container(
                    width: 30,
                    height: 3,
                    color: const Color(0xFFB0B0B0),
                  ),
                  const FlowSeparatorBox(width: 8),
                  Text(
                    DateTimeUtil.getMonthName(currentMonth.month - 1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
