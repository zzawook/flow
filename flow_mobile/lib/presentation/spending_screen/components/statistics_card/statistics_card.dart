import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/presentation/spending_screen/components/statistics_card/horizontal_stacked_bar_with_legend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// Statistics Section
class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: StoreConnector<FlowState, TransactionState>(
          converter: (store) => store.state.transactionState,
          builder: (context, transactionState) {
            Map<String, double> categoryAmount = {
              "Food": 0,
              "Transport": 0,
              "Groceries": 0,
              "Transfer": 0,
              "Entertainment": 0,
              "Others": 0,
            };
            for (var transaction in transactionState.transactions) {
              categoryAmount[transaction.category] =
                  categoryAmount[transaction.category]! + transaction.amount;
            }

            // Remove categories with 0 amount
            categoryAmount.removeWhere((key, value) => value == 0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${DateTimeUtil.getMonthName(DateTime.now().month)} ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Text(
                      'statistics',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                FlowSeparatorBox(height: 8),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$ ${transactionState.getExpenseInCentsForMonth(DateTime.now()).abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C864),
                        ),
                      ),
                    ],
                  ),
                ),
                FlowSeparatorBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: HorizontalStackedBarWithLegend(
                    categories: categoryAmount,
                  ),
                ),
                FlowSeparatorBox(height: 8),
                Container(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 24,
                    right: 8,
                    left: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View charts ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFFA6A6A6),
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 2),
                        child: Image.asset(
                          'assets/icons/vector.png',
                          width: 12,
                          height: 12,
                          color: Color(0xFFA19F9F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
