import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklySpendingCalendar extends StatefulWidget {
  const WeeklySpendingCalendar({super.key});

  @override
  State<WeeklySpendingCalendar> createState() => _WeeklySpendingCalendarState();
}

class _WeeklySpendingCalendarState extends State<WeeklySpendingCalendar> {
  /// A list of 7 maps, each with a single entry:
  /// e.g. [ {'2023-03-12': 197}, {'2023-03-13': -200}, ... ]
  final List<Map<String, dynamic>> last7DaysData = [
    {
      '2025-03-17': {'income': 197, 'expense': 200},
    },
    {
      '2025-03-18': {'income': 200, 'expense': 170},
    },
    {
      '2025-03-19': {'income': 0, 'expense': 10},
    },
    {
      '2025-03-20': {'income': 0, 'expense': 0},
    },
    {
      '2025-03-21': {'income': 0, 'expense': 0},
    },
    {
      '2025-03-22': {'income': 0, 'expense': 0},
    },
    {
      '2025-03-23': {'income': 0, 'expense': 0},
    },
  ];

  int currentSelectedIndex = -1;

  final List<Map<String, dynamic>> thisWeekData = [];

  List<Map<String, dynamic>> generateThisWeekData() {
    final today = DateTime.now();
    final thisWeekData = <Map<String, dynamic>>[];

    // start from last sunday
    final startIndex = last7DaysData.indexWhere((element) {
      final dateString = element.keys.first;
      final dateTime = parseDate(dateString);
      return dateTime.weekday == 7;
    });

    // if today is sunday, start from today
    final start = startIndex == -1 ? 0 : startIndex;

    for (var i = start; i < last7DaysData.length; i++) {
      thisWeekData.add(last7DaysData[i]);
    }

    // add the remaining days to thisWeekData with amount 0
    for (var i = 0; i < start; i++) {
      DateTime currentDate = today.add(Duration(days: i - start));
      thisWeekData.add({fromDate(currentDate): 0});
    }

    return thisWeekData;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 18),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children:
            last7DaysData.map((item) {
              // Each item is like {'yyyy-mm-dd': amount}
              // Extract the date string (key) and amount (value)
              final dateString = item.keys.first;
              final income = (item.values.first['income'] as num).toDouble();
              final expense = (item.values.first['expense'] as num).toDouble();

              // Parse date from 'yyyy-mm-dd'
              final dateTime = parseDate(dateString);

              // Check if this date is "today"
              final isToday = _isSameDay(dateTime, today);
              final isSelected =
                  currentSelectedIndex == last7DaysData.indexOf(item);

              // Format day name (e.g. "Sun", "Mon")
              final dayName = DateFormat('EEE').format(dateTime);
              final dateNumber = dateTime.day;

              // Decide color & sign for amount
              final incomeTextColor = Color(0xFF50C878);
              final expenseTextColor = Color(0x75000000);
              final incomeText =
                  income != 0 ? '+${income.toStringAsFixed(2)}' : '';
              final expenseText =
                  expense != 0 ? '-${expense.toStringAsFixed(2)}' : '';

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Day name (e.g. "Sun")
                    Text(
                      dayName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000),
                      ),
                    ),
                    // Date number, highlighted if today
                    GestureDetector(
                      onTap: () {
                        int newSelectedIndex = last7DaysData.indexOf(item);
                        if (newSelectedIndex == currentSelectedIndex) {
                          newSelectedIndex = -1;
                        }
                        setState(() {
                          currentSelectedIndex = newSelectedIndex;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: 8,
                          right: 8,
                        ),
                        decoration:
                            isToday
                                ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(
                                    0x16000000,
                                  ), // Dark circle for today
                                )
                                : isSelected
                                ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(
                                    0x6450C878,
                                  ), // Light circle for selected
                                )
                                : null,
                        child: Text(
                          dateNumber.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),

                    // Spending/transaction text
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
                                ? Color(0xFFFFFFFF)
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

  DateTime parseDate(String dateString) {
    final dateParts = dateString.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  String fromDate(DateTime datetime) {
    return DateFormat('yyyy-MM-dd').format(datetime);
  }

  /// Check if two DateTimes fall on the same calendar day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
