import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

class SpendingCalendar extends ConsumerStatefulWidget {
  final DateTime displayedMonth;
  final void Function(DateTime date) onDateSelected;

  const SpendingCalendar({
    super.key,
    required this.displayedMonth,
    required this.onDateSelected,
  });

  @override
  ConsumerState<SpendingCalendar> createState() => _SpendingCalendarState();
}

class _SpendingCalendarState extends ConsumerState<SpendingCalendar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final expenseColor = Theme.of(context).colorScheme.onSurface.withAlpha(140);

    final daysInMonth = DateTimeUtil.daysInMonth(
      widget.displayedMonth.year,
      widget.displayedMonth.month,
    );
    final firstDayOfWeek =
        DateTime(
          widget.displayedMonth.year,
          widget.displayedMonth.month,
          1,
        ).weekday;
    final startOffset = (firstDayOfWeek % 7);

    final dayOfWeekLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    final dayOfWeekRow = Row(
      children:
          dayOfWeekLabels.map((label) {
            return Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
    );

    List<Widget> dayCells = [];
    for (int i = 0; i < startOffset; i++) {
      dayCells.add(Expanded(child: Container()));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        widget.displayedMonth.year,
        widget.displayedMonth.month,
        day,
      );
      dayCells.add(
        Consumer(
          builder: (context, ref, child) {
            final transactionsAsync = ref.watch(transactionsProvider);
            
            return transactionsAsync.when(
              data: (transactions) {
                // Calculate stats for this date
                final dayTransactions = transactions.where((t) => 
                  DateTimeUtil.isSameDate(t.date, date)).toList();
                
                final income = dayTransactions
                    .where((t) => t.amount > 0)
                    .fold(0.0, (sum, t) => sum + t.amount);
                final expense = dayTransactions
                    .where((t) => t.amount < 0)
                    .fold(0.0, (sum, t) => sum + t.amount.abs());
                
                final isToday = DateTimeUtil.isSameDate(date, DateTime.now());
                final isSelected = DateTimeUtil.isSameDate(date, selectedDate);
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (date.isAfter(DateTime.now())) return;
                      widget.onDateSelected(date);
                      setState(() {
                        selectedDate = date;
                      });
                    },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                            left: 9,
                            right: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isToday
                                    ? Theme.of(context).colorScheme.surfaceBright
                                    : isSelected
                                    ? Theme.of(context).primaryColorLight
                                    : null,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$day",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color:
                                  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withValues(
                                        alpha:
                                            date.isAfter(DateTime.now())
                                                ? 0.3
                                                : 0.8,
                                      )
                                      : Colors.black.withValues(
                                        alpha:
                                            date.isAfter(DateTime.now())
                                                ? 0.3
                                                : 1.0,
                                      ),
                            ),
                          ),
                        ),
                        Text(
                          date.isAfter(DateTime.now())
                              ? ""
                              : income > 0
                              ? "+${income.toStringAsFixed(2)}"
                              : expense > 0
                              ? "-${expense.toStringAsFixed(2)}"
                              : "",
                          style: TextStyle(
                            fontFamily: 'Inter',
                                color:
                                    income > 0
                                    ? Theme.of(context).primaryColor
                                    : expense > 0
                                    ? expenseColor
                                    : Theme.of(context).primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          date.isAfter(DateTime.now()) || (income == 0)
                              ? ""
                              : expense.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: expenseColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => Expanded(child: Container()),
              error: (error, stack) => Expanded(child: Container()),
            );
          },
        ),
          },
        ),
      );
    }

    List<Row> rows = [];
    for (int i = 0; i < dayCells.length; i += 7) {
      final slice = dayCells.sublist(
        i,
        i + 7 > dayCells.length ? dayCells.length : i + 7,
      );
      while (slice.length < 7) {
        slice.add(Expanded(child: Container()));
      }
      rows.add(Row(children: slice));
    }

    return Column(
      children: [
        dayOfWeekRow,
        const SizedBox(height: 8),
        ...rows.map(
          (r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: r,
          ),
        ),
      ],
    );
  }
}

class CalendarCellState {
  final double income;
  final double expense;
  final bool isToday;
  final bool isSelected;

  CalendarCellState({
    required this.income,
    required this.expense,
    required this.isToday,
    required this.isSelected,
  });
}
