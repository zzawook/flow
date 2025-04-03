import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingDetailTopBar extends StatelessWidget {
  const SpendingDetailTopBar({
    super.key,
    required this.previousScreenRoute,
    required this.displayMonthYear,
  });

  final String previousScreenRoute;

  final DateTime displayMonthYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlowButton(
          onPressed: () {
            Navigator.pushNamed(context, previousScreenRoute);
          },
          child: Image.asset(
            'assets/icons/previous.png',
            height: 20,
            width: 20,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
        ),
        Image.asset('assets/icons/camera.png', height: 25, width: 25),
      ],
    );
  }
}
