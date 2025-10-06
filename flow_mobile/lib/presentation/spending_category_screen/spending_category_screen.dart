import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';
import 'package:flow_mobile/presentation/shared/spending/stacked_bar.dart';
import 'package:flow_mobile/presentation/spending_category_detail_screen/spending_category_detail_screen.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
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

  Future<void> _onRefresh() async {
    Navigator.pushNamed(
      context,
      AppRoutes.refresh,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideTop,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Theme.of(context).primaryColor,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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

                    final sortedCategories = categoryAmount.entries.toList()
                      ..sort((a, b) => a.value.compareTo(b.value));

                    // BUILD
                    return Column(
                      children: [
                        FlowTopBar(title: Text("")),
                        const FlowSeparatorBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MonthSelector(
                                displayMonthYear: displayMonthYear,
                                displayMonthYearSetter: setDisplayMonthYear,
                              ),
                            ],
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
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
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

    final logoService = getIt<LogoService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: Theme.of(context).cardColor,
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
                      width: 36,
                      child: Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
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
                        logoService.getCategoryIcon(entry.key, isDark),
                        fit: BoxFit.contain,
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '\$ ${entry.value.abs().toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyMedium,
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
        color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
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
