import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingCalendar extends StatefulWidget {
  final DateTime displayedMonth;

  const SpendingCalendar({super.key, required this.displayedMonth});

  @override
  State<SpendingCalendar> createState() => _SpendingCalendarState();
}

class _SpendingCalendarState extends State<SpendingCalendar> {
  @override
  Widget build(BuildContext context) {
    // We'll create a simple grid for the days of the week + days of the month
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
    // In Dart, weekday: 1 = Monday, 7 = Sunday. We'll align to Sunday=0, Monday=1, etc. for this grid.
    final startOffset = (firstDayOfWeek % 7); // 0 if Sunday, 1 if Monday, etc.

    // Build day-of-week header
    final dayOfWeekLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    final dayOfWeekRow = Row(
      children:
          dayOfWeekLabels.map((label) {
            return Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
    );

    // Build calendar days grid
    List<Widget> dayCells = [];
    // Add empty slots for days before the first day of the month
    for (int i = 0; i < startOffset; i++) {
      dayCells.add(Expanded(child: Container()));
    }

    // Add actual days
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(
        widget.displayedMonth.year,
        widget.displayedMonth.month,
        day,
      );
      dayCells.add(
        StoreConnector<FlowState, CalendarCellState>(
          distinct: true,
          converter: (store) {
            final transactionState = store.state.transactionState;
            var dateStatistics = transactionState
                .getTransactionStatisticForDate(date);
            return CalendarCellState(
              income: dateStatistics.income,
              expense: dateStatistics.expense,
              isToday: DateTimeUtil.isSameDate(date, DateTime.now()),
              isSelected: DateTimeUtil.isSameDate(
                date,
                store
                    .state
                    .screenState
                    .spendingScreenState
                    .calendarSelectedDate,
              ),
            );
          },
          builder: (context, calendarCellState) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (date.isAfter(DateTime.now())) {
                    return;
                  }
                  StoreProvider.of<FlowState>(
                    context,
                  ).dispatch(SetCalendarSelectedDateAction(date));
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
                            calendarCellState.isToday
                                ? Color(0x16000000)
                                : calendarCellState.isSelected
                                ? Color(0x6450C878)
                                : null,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$day",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF000000).withValues(
                            alpha: date.isAfter(DateTime.now()) ? 0.3 : 1.0,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      date.isAfter(DateTime.now())
                          ? ""
                          : calendarCellState.income > 0
                          ? "+${calendarCellState.income.toStringAsFixed(2)}"
                          : calendarCellState.expense < 0
                          ? calendarCellState.expense.toStringAsFixed(2)
                          : "",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color:
                            calendarCellState.income > 0
                                ? Color(0xFF50C878)
                                : calendarCellState.expense < 0
                                ? Color(0xFF757575)
                                : Color(0xFF50C878),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      date.isAfter(DateTime.now()) ||
                              (calendarCellState.income == 0)
                          ? ""
                          : calendarCellState.expense.toStringAsFixed(2),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF757575),
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

    // We'll create rows of 7 columns each
    List<Row> calendarRows = [];
    for (int i = 0; i < dayCells.length; i += 7) {
      final rowCells = dayCells.sublist(
        i,
        i + 7 > dayCells.length ? dayCells.length : i + 7,
      );
      // If rowCells < 7, fill with empty containers
      while (rowCells.length < 7) {
        rowCells.add(Expanded(child: Container()));
      }
      calendarRows.add(Row(children: rowCells));
    }

    return Column(
      children: [
        dayOfWeekRow,
        const SizedBox(height: 8),
        ...calendarRows.map(
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
