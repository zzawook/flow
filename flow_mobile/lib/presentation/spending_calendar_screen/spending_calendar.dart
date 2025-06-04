import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingCalendar extends StatefulWidget {
  final DateTime displayedMonth;
  final void Function(DateTime date) onDateSelected;

  const SpendingCalendar({
    super.key,
    required this.displayedMonth,
    required this.onDateSelected,
  });

  @override
  State<SpendingCalendar> createState() => _SpendingCalendarState();
}

class _SpendingCalendarState extends State<SpendingCalendar> {
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
        StoreConnector<FlowState, CalendarCellState>(
          distinct: true,
          converter: (store) {
            final s = store.state.transactionState;
            final stats = s.getTransactionStatisticForDate(date);
            return CalendarCellState(
              income: stats.income,
              expense: stats.expense,
              isToday: DateTimeUtil.isSameDate(date, DateTime.now()),
              isSelected: DateTimeUtil.isSameDate(date, selectedDate),
            );
          },
          builder: (ctx, cell) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (date.isAfter(DateTime.now())) return;
                  widget.onDateSelected(date);
                  StoreProvider.of<FlowState>(
                    ctx,
                    listen: false,
                  ).dispatch(SetCalendarSelectedDateAction(date));
                  setState(() {
                    selectedDate = date;
                  });
                },
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
                            cell.isToday
                                ? Theme.of(context).colorScheme.surfaceBright
                                : cell.isSelected
                                ? Theme.of(ctx).primaryColorLight
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
                          : cell.income > 0
                          ? "+${cell.income.toStringAsFixed(2)}"
                          : cell.expense < 0
                          ? cell.expense.toStringAsFixed(2)
                          : "",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color:
                            cell.income > 0
                                ? Theme.of(ctx).primaryColor
                                : cell.expense < 0
                                ? expenseColor
                                : Theme.of(ctx).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      date.isAfter(DateTime.now()) || (cell.income == 0)
                          ? ""
                          : cell.expense.toStringAsFixed(2),
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
