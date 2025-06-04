import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/insight_sentences/spending_compareto_last_month_insight.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_list.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/weekly_spending_calendar.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/spending/spending_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// Monthly Spending Overview Section
class MonthlySpendingOverview extends StatefulWidget {
  const MonthlySpendingOverview({super.key});

  @override
  State<MonthlySpendingOverview> createState() =>
      _MonthlySpendingOverviewState();
}

class _MonthlySpendingOverviewState extends State<MonthlySpendingOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: StoreConnector<FlowState, SpendingOverviewState>(
        // distinct: true,
        converter: (store) {
          DateTime displayedMonth =
              store.state.screenState.spendingScreenState.displayedMonth;

          DateTime today = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
          DateTime lastSunday = today.subtract(
            Duration(days: today.weekday % 7),
          );
          List<Transaction> transactions = store.state.transactionState
              .getTransactionsFromTo(lastSunday, today);
          return SpendingOverviewState(
            displayedMonth: displayedMonth,
            weeklySpendingCalendarDisplayWeek:
                store
                    .state
                    .screenState
                    .spendingScreenState
                    .weeklySpendingCalendarDisplayWeek,
            transactions: transactions,
          );
        },
        builder:
            (context, spendingOverviewState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpendingHeader(
                        displayMonthYear: spendingOverviewState.displayedMonth,
                        weeklySpendingCalendarDisplayWeek:
                            spendingOverviewState
                                .weeklySpendingCalendarDisplayWeek,
                      ),

                      SpendingComparetoLastMonthInsight(),

                      WeeklySpendingCalendar(),

                      TransactionsList(
                        transactions: spendingOverviewState.transactions,
                      ),
                    ],
                  ),
                ),
                FlowButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/spending/detail',
                      arguments: CustomPageRouteArguments(
                        transitionType: TransitionType.slideLeft,
                        extraData: spendingOverviewState.displayedMonth,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'View Transactions ',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFFA6A6A6),
                            fontSize: 18,
                          ),
                        ),
                        Image.asset(
                          'assets/icons/arrow_right.png',
                          width: 12,
                          height: 12,
                          color: const Color(0xFFA19F9F),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

class SpendingOverviewState {
  DateTime displayedMonth;
  List<Transaction> transactions;
  DateTime weeklySpendingCalendarDisplayWeek;

  SpendingOverviewState({
    required this.displayedMonth,
    required this.transactions,
    required this.weeklySpendingCalendarDisplayWeek,
  });
}
