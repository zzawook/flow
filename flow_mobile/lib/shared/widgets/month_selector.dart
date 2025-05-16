import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final DateTime displayMonthYear;
  final Function(DateTime) displayMonthYearSetter;

  const MonthSelector({
    super.key,
    required this.displayMonthYear,
    required this.displayMonthYearSetter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: FlowButton(
            onPressed: () {
              displayMonthYearSetter(
                DateTime(displayMonthYear.year, displayMonthYear.month - 1),
              );
            }, // Previous Month
            child: Image.asset(
              'assets/icons/prevMonth.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              DateTimeUtil.getMonthName(displayMonthYear.month),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 8),
          child: FlowButton(
            onPressed: () {
              if (displayMonthYear.month == DateTime.now().month &&
                  displayMonthYear.year == DateTime.now().year) {
                return;
              }
              displayMonthYearSetter(
                DateTime(displayMonthYear.year, displayMonthYear.month + 1),
              );
            },
            child: Image.asset(
              displayMonthYear.month < DateTime.now().month ||
                      displayMonthYear.year < DateTime.now().year
                  ? 'assets/icons/nextMonth_exists.png'
                  : 'assets/icons/nextMonth_not_exists.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}