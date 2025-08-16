import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
// Import your chart widgets
import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/horizontal_stacked_bar_with_legend.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A card that displays statistics and allows toggling
/// between a horizontal bar chart and a pie chart.
class SpendingByCategoryCard extends ConsumerStatefulWidget {
  const SpendingByCategoryCard({super.key});

  @override
  ConsumerState<SpendingByCategoryCard> createState() => _SpendingByCategoryCardState();
}

class _SpendingByCategoryCardState extends ConsumerState<SpendingByCategoryCard> {
  @override
  Widget build(BuildContext context) {
    final spendingScreenState = ref.watch(spendingScreenStateProvider);
    
    return Consumer(
      builder: (context, ref, child) {
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
            child: Consumer(
              builder: (context, ref, child) {
                final transactionState = ref.watch(transactionStateProvider);
                List<String> categories =
                    SpendingCategoryUtil.getAllCategories();

                // Calculate total negative amounts (expenses) by category
                final Map<String, double> categoryAmount = {
                  for (var category in categories) category: 0.0,
                };

                final monthOfInterest = spendingScreenState.displayedMonth;
                final monthTransactions = transactionState.transactions
                    .where((transaction) {
                      return transaction.date.year == monthOfInterest.year &&
                             transaction.date.month == monthOfInterest.month;
                    })
                    .toList();
                
                for (var transaction in monthTransactions) {
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
                            '\$ ${monthTransactions.where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount).abs().toStringAsFixed(2)}',
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
