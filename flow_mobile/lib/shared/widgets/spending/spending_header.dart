import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingHeader extends StatelessWidget {
  const SpendingHeader({super.key, required this.displayMonthYear});

  final DateTime displayMonthYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FlowButton(
                      onPressed: () {
                        StoreProvider.of<FlowState>(
                          context,
                        ).dispatch(DecrementDisplayedMonthAction());
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: FlowButton(
                      onPressed: () {
                        StoreProvider.of<FlowState>(
                          context,
                        ).dispatch(IncrementDisplayedMonthAction());
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
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  () {
                    var balance =
                        StoreProvider.of<FlowState>(context)
                            .state
                            .transactionState
                            .getExpenseInCentsForMonth(displayMonthYear)
                            .abs();
                    // if (balance < 0) {
                    //   return '-\$${(-balance).toStringAsFixed(2)}';
                    // }
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
        Container(
          height: 80,
          width: 150,
          decoration: BoxDecoration(
            color: Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text('Graph Placeholder'), // Placeholder for graph
        ),
      ],
    );
  }
}
