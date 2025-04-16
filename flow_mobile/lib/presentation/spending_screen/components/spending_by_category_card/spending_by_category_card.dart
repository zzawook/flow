import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_graph_screen/spending_pie_chart.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/utils/spending_category_util.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';

// Import your chart widgets
import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/horizontal_stacked_bar_with_legend.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toggle_switch/toggle_switch.dart';

/// A card that displays statistics and allows toggling
/// between a horizontal bar chart and a pie chart.
class SpendingByCategoryCard extends StatefulWidget {
  const SpendingByCategoryCard({super.key});

  @override
  State<SpendingByCategoryCard> createState() => _SpendingByCategoryCardState();
}

class _SpendingByCategoryCardState extends State<SpendingByCategoryCard> {
  /// If true, show the pie chart. If false, show the horizontal bar.
  bool _showPieChart = false;

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/spending/graph',
          arguments: CustomPageRouteArguments(
            transitionType: TransitionType.slideLeft,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: StoreConnector<FlowState, TransactionState>(
          converter: (store) => store.state.transactionState,
          builder: (context, transactionState) {
            final List<String> categories =
                SpendingCategoryUtil.getAllCategories();

            // Calculate total negative amounts (expenses) by category
            final Map<String, double> categoryAmount = {
              for (var category in categories) category: 0.0,
            };
            for (var transaction in transactionState.getTransactionsForMonth(
              DateTime(DateTime.now().year, DateTime.now().month),
            )) {
              if (transaction.amount < 0) {
                categoryAmount[transaction.category] =
                    categoryAmount[transaction.category]! + transaction.amount;
              }
            }

            // Remove any category with zero amount
            categoryAmount.removeWhere((key, value) => value == 0);

            final sortedCategories =
                categoryAmount.entries.toList()
                  ..sort((a, b) => a.value.compareTo(b.value));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row: "April statistics" (example)
                Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateTimeUtil.getMonthName(DateTime.now().month)} ',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          FlowSeparatorBox(height: 4),
                          const Text(
                            'Category Breakdown',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),

                      Expanded(child: SizedBox()),

                      ChartTypeToggleSwitch(
                        initialValue: _showPieChart,
                        onToggle: (value) {
                          setState(() {
                            _showPieChart = value;
                          });
                        },
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
                      _showPieChart
                          ? FlowSeparatorBox(height: 24)
                          : Text(
                            '\$ ${transactionState.getExpenseForMonth(DateTime.now()).abs().toStringAsFixed(2)}',
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

                _showPieChart ? FlowSeparatorBox(height: 16) : Container(),

                // Conditionally show either the horizontal bar or the pie chart
                SizedBox(
                  width: double.infinity,
                  child:
                      _showPieChart
                          ? SpendingPieChart(
                            // Adjust argument name/type to match your SpendingPieChart
                            sortedCategories: sortedCategories,
                            radius: 140,
                          )
                          : Padding(
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
  }
}

class ChartTypeToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;

  const ChartTypeToggleSwitch({
    super.key,
    required this.initialValue,
    required this.onToggle,
  });

  @override
  State<ChartTypeToggleSwitch> createState() => _CustomIconToggleSwitchState();
}

class _CustomIconToggleSwitchState extends State<ChartTypeToggleSwitch> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // We treat index 0 as "bar" (false) and index 1 as "pie" (true)
    _currentIndex = widget.initialValue ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: _currentIndex,
      totalSwitches: 2,
      // Provide empty labels because we want only the icon to show
      labels: ["", ""],
      // customIcons accepts a list of widgets.
      customIcons: [
        Icon(Icons.bar_chart_rounded, size: 24),
        Icon(Icons.pie_chart, size: 24),
      ],
      // Customize appearance as needed
      cornerRadius: 20.0,
      minWidth: 50.0,
      minHeight: 35.0,
      activeBgColors: [
        [Color(0xFF50C864)],
        [Color(0xFF50C864)],
      ],
      inactiveBgColor: Colors.grey[200],
      // The textStyle won't really matter here because we provided empty labels.
      onToggle: (index) {
        setState(() {
          _currentIndex = index ?? 0;
          widget.onToggle(
            _currentIndex == 1,
          ); // index 1 means "pie" is enabled.
        });
      },
    );
  }
}
