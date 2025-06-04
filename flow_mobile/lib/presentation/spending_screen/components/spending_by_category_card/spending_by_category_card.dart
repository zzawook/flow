import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
// Import your chart widgets
import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/horizontal_stacked_bar_with_legend.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// A card that displays statistics and allows toggling
/// between a horizontal bar chart and a pie chart.
class SpendingByCategoryCard extends StatefulWidget {
  const SpendingByCategoryCard({super.key});

  @override
  State<SpendingByCategoryCard> createState() => _SpendingByCategoryCardState();
}

class _SpendingByCategoryCardState extends State<SpendingByCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, SpendingScreenState>(
      converter: (store) => store.state.screenState.spendingScreenState,
      builder: (context, spendingScreenState) {
        return FlowButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/spending/category',
              arguments: CustomPageRouteArguments(
                transitionType: TransitionType.slideLeft,
                extraData: spendingScreenState.displayedMonth,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 24, bottom: 0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: StoreConnector<FlowState, TransactionState>(
              converter: (store) => store.state.transactionState,
              builder: (context, transactionState) {
                List<String> categories =
                    SpendingCategoryUtil.getAllCategories();

                // Calculate total negative amounts (expenses) by category
                final Map<String, double> categoryAmount = {
                  for (var category in categories) category: 0.0,
                };

                final monthOfInterest = spendingScreenState.displayedMonth;
                for (var transaction in transactionState
                    .getTransactionsForMonth(monthOfInterest)) {
                  if (transaction.amount < 0) {
                    categoryAmount[transaction.category] =
                        categoryAmount[transaction.category]! +
                        transaction.amount;
                  }
                }

                // Remove any category with zero amount
                categoryAmount.removeWhere((key, value) => value == 0);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 24, left: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category Breakdown',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    FlowSeparatorBox(height: 8),

                    // Total expense amount
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$ ${transactionState.getExpenseForMonth(spendingScreenState.displayedMonth).abs().toStringAsFixed(2)}',
                            style: const TextStyle(
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

                    // Conditionally show either the horizontal bar or the pie chart
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: HorizontalStackedBarWithLegend(
                          categories: categoryAmount,
                        ),
                      ),
                    ),

                    FlowSeparatorBox(height: 8),

                    // Bottom "View charts" row
                    Container(
                      padding: const EdgeInsets.only(
                        top: 16,
                        bottom: 24,
                        right: 8,
                        left: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'More detailed breakdown ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFFA6A6A6),
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: Image.asset(
                              'assets/icons/arrow_right.png',
                              width: 12,
                              height: 12,
                              color: const Color(0xFFA19F9F),
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
      },
    );
  }
}
