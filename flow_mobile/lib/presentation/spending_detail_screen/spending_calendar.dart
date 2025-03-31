import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
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
        StoreConnector<FlowState, TransactionState>(
          converter: (store) => store.state.transactionState,
          builder: (context, transactionState) {
            var dateStatistics = transactionState
                .getTransactionStatisticForDate(date);
            return Expanded(
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
                          DateTimeUtil.sameDate(date, DateTime.now())
                              ? const Color(0x16000000)
                              : null,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$day",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: Color(0xFF000000).withValues(
                          alpha: date.isAfter(DateTime.now()) ? 0.3 : 1.0,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    date.isAfter(DateTime.now())
                        ? ""
                        : dateStatistics.income > 0
                        ? "+\$${dateStatistics.income.toStringAsFixed(2)}"
                        : dateStatistics.expense < 0
                        ? "\$${dateStatistics.expense.toStringAsFixed(2)}"
                        : "",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color:
                          dateStatistics.income > 0
                              ? Color(0xFF50C878)
                              : dateStatistics.expense < 0
                              ? Color(0xFF757575)
                              : Color(0xFF50C878),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    date.isAfter(DateTime.now()) || (dateStatistics.income == 0)
                        ? ""
                        : "\$${dateStatistics.expense.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF757575),
                      fontSize: 12,
                    ),
                  ),
                ],
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
