import 'package:flow_mobile/common/flow_button.dart';
import 'package:flow_mobile/screens/spending_screen/components/spending_overview_card/insight_sentences/spending_compareto_last_month_insight.dart';
import 'package:flow_mobile/screens/spending_screen/components/spending_overview_card/transaction_list.dart';
import 'package:flow_mobile/screens/spending_screen/components/spending_overview_card/weekly_spending_calendar.dart';
import 'package:flutter/widgets.dart';

/// Monthly Spending Overview Section
class MonthlySpendingOverview extends StatelessWidget {
  const MonthlySpendingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                                  onPressed: () {}, // Previous Month
                                  child: Image.asset(
                                    'assets/icons/prevMonth.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              Text(
                                'January',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: FlowButton(
                                  onPressed: () {},
                                  child: Image.asset(
                                    'assets/icons/nextMonth.png',
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
                              '\$ 3734.35',
                              style: TextStyle(
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
                      decoration: BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Text('Graph Placeholder'), // Placeholder for graph
                    ),
                  ],
                ),
                SpendingComparetoLastMonthInsight(),

                WeeklySpendingCalendar(),

                const TransactionsList(),
              ],
            ),
          ),

          FlowButton(
            onPressed: () {
              // Handle navigation or show more account details.
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
                    style: TextStyle(color: Color(0xFFA6A6A6), fontSize: 18),
                  ),
                  Image.asset(
                    'assets/icons/vector.png',
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
    );
  }
}
