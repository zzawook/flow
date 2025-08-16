import 'package:flow_mobile/presentation/home_screen/home_screen_constants.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_tag.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

class SpendingCategoryDetailScreen extends ConsumerStatefulWidget {
  final String category;
  final DateTime displayMonthYear;

  const SpendingCategoryDetailScreen({
    super.key,
    required this.category,
    required this.displayMonthYear,
  });

  @override
  ConsumerState<SpendingCategoryDetailScreen> createState() =>
      _SpendingCategoryDetailScreenState();
}

class _SpendingCategoryDetailScreenState
    extends ConsumerState<SpendingCategoryDetailScreen> {
  late DateTime displayMonthYear;

  @override
  void initState() {
    super.initState();
    displayMonthYear = widget.displayMonthYear;
  }

  void displayMonthYearSetter(DateTime monthYear) {
    setState(() {
      displayMonthYear = monthYear;
    });
  }

  Future<void> _onRefresh() async {
    Navigator.pushNamed(
      context,
      HomeScreenRoutes.refresh,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideTop,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).cardColor,
      child: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true, // important!
              child: Consumer(
                builder: (context, ref, child) {
                  final transactionsAsync = ref.watch(transactionsProvider);
                  
                  return transactionsAsync.when(
                    data: (allTransactions) {
                      // Filter transactions by category and date range
                      final startDate = DateTime(
                        displayMonthYear.year,
                        displayMonthYear.month,
                        1,
                      );
                      final endDate = DateTime(
                        displayMonthYear.year,
                        displayMonthYear.month + 1,
                        0,
                      ).isBefore(DateTime.now())
                          ? DateTime(
                              displayMonthYear.year,
                              displayMonthYear.month + 1,
                              0,
                            )
                          : DateTime.now();
                      
                      final transactions = allTransactions.where((t) =>
                        t.category == widget.category &&
                        t.date.isAfter(startDate.subtract(Duration(days: 1))) &&
                        t.date.isBefore(endDate.add(Duration(days: 1)))
                      ).toList();
                  final totalTransactionAmount = transactions.fold(
                    0.0,
                    (previousValue, element) => previousValue + element.amount,
                  );
                  return Column(
                    children: [
                      FlowTopBar(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MonthSelector(
                              displayMonthYear: displayMonthYear,
                              displayMonthYearSetter: displayMonthYearSetter,
                            ),
                          ],
                        ),
                      ),
                      BalanceSection(
                        category: widget.category,
                        balance: totalTransactionAmount.abs().toStringAsFixed(
                          2,
                        ),
                        transactionCount: transactions.length,
                      ),

                      Container(
                        height: 12,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).canvasColor
                                : const Color(0xFF303030),
                      ),

                      Expanded(
                        child: TransactionList(transactions: transactions),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              );
            },
          ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceSection extends StatelessWidget {
  final String balance;
  final String category;
  final int transactionCount;

  const BalanceSection({
    super.key,
    required this.category,
    required this.balance,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransactionTag(tag: category, fontSize: 16),
          FlowSeparatorBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$ $balance',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          FlowSeparatorBox(height: 32),
          Text(
            '$transactionCount transactions',
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}

class SpendingCategoryDetailScreenArguments {
  final String category;
  final DateTime displayMonthYear;

  SpendingCategoryDetailScreenArguments({
    required this.category,
    required this.displayMonthYear,
  });
}
