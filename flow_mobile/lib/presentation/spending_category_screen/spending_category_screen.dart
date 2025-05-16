import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_category_detail_screen/spending_category_detail_screen.dart';
import 'package:flow_mobile/presentation/spending_category_screen/spending_graph_top_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/month_selector.dart';
import 'package:flow_mobile/shared/widgets/spending/stacked_bar.dart';
import 'package:flow_mobile/shared/utils/spending_category_util.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingCategoryScreen extends StatefulWidget {
  final DateTime displayMonthYear;

  const SpendingCategoryScreen({super.key, required this.displayMonthYear});

  @override
  State<SpendingCategoryScreen> createState() => _SpendingCategoryScreenState();
}

class _SpendingCategoryScreenState extends State<SpendingCategoryScreen> {
  late DateTime displayMonthYear;

  @override
  void initState() {
    super.initState();
    displayMonthYear = widget.displayMonthYear;
  }

  void setDisplayMonthYear(DateTime monthYear) {
    setState(() {
      displayMonthYear = monthYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 72),
                child: StoreConnector<FlowState, TransactionState>(
                  converter: (store) => store.state.transactionState,
                  builder: (context, transactionState) {
                    List<Transaction> transactions = transactionState
                        .getTransactionsForMonth(
                          DateTime(
                            displayMonthYear.year,
                            displayMonthYear.month,
                          ),
                        );
                    Map<String, double> categoryAmount = {};

                    double total = 0.0;

                    // Calculate the total amount for each category
                    for (var transaction in transactions) {
                      if (transaction.amount > 0) {
                        continue; // Skip income transactions
                      }
                      if (categoryAmount.containsKey(transaction.category)) {
                        categoryAmount[transaction.category] =
                            categoryAmount[transaction.category]! +
                            transaction.amount;
                      } else {
                        categoryAmount[transaction.category] =
                            transaction.amount;
                      }
                      total += transaction.amount.abs();
                    }

                    // Remove categories with 0 amount
                    categoryAmount.removeWhere((key, value) => value == 0);

                    final sortedCategories =
                        categoryAmount.entries.toList()
                          ..sort((a, b) => a.value.compareTo(b.value));

                    // BUILD
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 24),
                          child: SpendingGraphTopBar(),
                        ),
                        const FlowSeparatorBox(height: 45),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: MonthSelector(
                            displayMonthYear: displayMonthYear,
                            displayMonthYearSetter: setDisplayMonthYear,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 24,
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '\$ ${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xAA000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlowSeparatorBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: StackedBar(
                            total: total,
                            height: 32,
                            entries: sortedCategories,
                          ),
                        ),
                        const FlowSeparatorBox(height: 24),
                        SpendingCategoryList(
                          sortedCategories: sortedCategories,
                          displayedMonthYear: displayMonthYear,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class SpendingCategoryList extends StatelessWidget {
  final List<MapEntry<String, dynamic>> sortedCategories;
  final DateTime displayedMonthYear;

  const SpendingCategoryList({
    super.key,
    required this.sortedCategories,
    required this.displayedMonthYear,
  });

  @override
  Widget build(BuildContext context) {
    final total = sortedCategories.fold(0.0, (double sum, entry) {
      return sum + entry.value.abs();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        ...sortedCategories.map((entry) {
          final percentage = (entry.value.abs() / total * 100);
          return FlowButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/spending/category/detail",
                arguments: CustomPageRouteArguments(
                  transitionType: TransitionType.slideLeft,
                  extraData: SpendingCategoryDetailScreenArguments(
                    category: entry.key,
                    displayMonthYear: displayedMonthYear,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8,
                  top: 16,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 35,
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const FlowSeparatorBox(width: 8),
                    Container(
                      width: 42,
                      height: 42,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: SpendingCategoryUtil.getCategoryColor(entry.key),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        SpendingCategoryUtil.getCategoryIcon(entry.key),
                      ),
                    ),
                    const FlowSeparatorBox(width: 8),
                    // Wrap the Column with Expanded to constrain its width.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                '\$ ${entry.value.abs().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                          const FlowSeparatorBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: PercentageBar(
                                  percentage: percentage,
                                  color: SpendingCategoryUtil.getCategoryColor(
                                    entry.key,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const FlowSeparatorBox(width: 8),
                    Image.asset(
                      'assets/icons/arrow_right.png',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class PercentageBar extends StatelessWidget {
  final double percentage;
  final Color color;

  const PercentageBar({
    super.key,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(7),
      ),
      child: FractionallySizedBox(
        widthFactor: percentage / 100,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
