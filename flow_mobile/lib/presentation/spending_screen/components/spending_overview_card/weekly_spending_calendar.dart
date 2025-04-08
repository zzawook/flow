import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/models/WeeklySpendingData.dart';
import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class WeeklySpendingCalendar extends StatefulWidget {
  final List<Transaction> transactions;

  const WeeklySpendingCalendar({super.key, required this.transactions});

  @override
  State<WeeklySpendingCalendar> createState() => _WeeklySpendingCalendarState();
}

class _WeeklySpendingCalendarState extends State<WeeklySpendingCalendar> {
  DateTime currentSelectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final lastSunday = today.subtract(Duration(days: today.weekday % 7));

    // Filter last 7 days transactions from the provided list
    final last7DaysTransactions =
        widget.transactions
            .where(
              (t) =>
                  t.date.isAfter(
                    lastSunday.subtract(const Duration(days: 1)),
                  ) &&
                  t.date.isBefore(today.add(const Duration(days: 1))),
            )
            .toList();

    // Build weekly spending data
    WeeklySpendingData weeklySpendingData = WeeklySpendingData();
    for (var tx in last7DaysTransactions) {
      weeklySpendingData.addTransaction(tx);
    }
    final last7DaysData = weeklySpendingData.getWeeklySpendingData();

    // Generate keys for each day of the current week
    final keys = List.generate(
      7,
      (index) => today.subtract(Duration(days: today.weekday - 1 - index)),
    );

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 18),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            keys.map((dateTime) {
              final item = last7DaysData[dateTime] ?? {};
              final income = item["income"] ?? 0.0;
              final expense = item["expense"] ?? 0.0;
              final isToday = _isSameDay(dateTime, today);
              final isSelected = _isSameDay(dateTime, currentSelectedDate);
              final dayName = DateFormat('EEE').format(dateTime);
              final dateNumber = dateTime.day;
              final incomeTextColor = const Color(0xFF50C878);
              final expenseTextColor = const Color(0x75000000);
              final incomeText =
                  income != 0 ? '+${income.toStringAsFixed(2)}' : '';
              final expenseText =
                  expense != 0 ? '-${expense.toStringAsFixed(2)}' : '';

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(dayName, style: const TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        if (dateTime.isAfter(today)) {
                          return;
                        }
                        setState(() {
                          StoreProvider.of<FlowState>(
                            context,
                            listen: false,
                          ).dispatch(SetSelectedDateAction(dateTime));
                          currentSelectedDate = dateTime;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration:
                            isToday
                                ? const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0x16000000),
                                )
                                : isSelected
                                ? const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0x6450C878),
                                )
                                : null,
                        child: Text(
                          dateNumber.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                dateTime.isAfter(today)
                                    ? Color(0xFFB0B0B0)
                                    : Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      onlyHasExpense(income, expense)
                          ? expenseText
                          : incomeText,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            onlyHasExpense(income, expense)
                                ? expenseTextColor
                                : incomeTextColor,
                      ),
                    ),
                    Text(
                      expenseText,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            onlyHasExpense(income, expense)
                                ? const Color(0xFFFFFFFF)
                                : expenseTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  bool onlyHasExpense(double income, double expense) {
    return income == 0 && expense != 0;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
