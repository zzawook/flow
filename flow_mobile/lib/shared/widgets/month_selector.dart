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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: FlowButton(
            onPressed: () {
              displayMonthYearSetter(
                DateTime(displayMonthYear.year, displayMonthYear.month - 1),
              );
            }, // Previous Month
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(240),
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Center(
            child: Text(
              '${DateTimeUtil.getMonthName(displayMonthYear.month).substring(0, 3)}${displayMonthYear.year == DateTime.now().year ? '' : ' ${displayMonthYear.year.toString().substring(2)}\''}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(240),
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
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 35,
              color:
                  displayMonthYear.month < DateTime.now().month ||
                          displayMonthYear.year < DateTime.now().year
                      ? Theme.of(context).colorScheme.onSurface.withAlpha(240)
                      : Theme.of(context).colorScheme.onSurface.withAlpha(80),
            ),
          ),
        ),
      ],
    );
  }
}
