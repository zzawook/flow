import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/spending_calendar.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

class SpendingCalendarScreen extends ConsumerStatefulWidget {
  final DateTime displayedMonth;
  const SpendingCalendarScreen({super.key, required this.displayedMonth});

  @override
  ConsumerState<SpendingCalendarScreen> createState() => _SpendingDetailScreenState();
}

class _SpendingDetailScreenState extends ConsumerState<SpendingCalendarScreen> {
  late DateTime displayedMonth;
  final Map<DateTime, GlobalKey> _detailKeys = {};

  @override
  void initState() {
    super.initState();
    displayedMonth = widget.displayedMonth;
    _initDetailKeys();
  }

  void _initDetailKeys() {
    _detailKeys.clear();
    final daysInMonth = DateTimeUtil.daysInMonth(
      displayedMonth.year,
      displayedMonth.month,
    );
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(displayedMonth.year, displayedMonth.month, day);
      _detailKeys[date] = GlobalKey();
    }
  }

  void setDisplayedMonth(DateTime month) {
    setState(() {
      displayedMonth = month;
      _initDetailKeys();
    });
  }

  void _handleDateTap(DateTime date) {
    final key = _detailKeys[DateTime(date.year, date.month, date.day)];
    if (key?.currentContext == null) return;

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: RefreshIndicator.adaptive(
        onRefresh: () {
          Navigator.pushNamed(
            context,
            "/refresh",
            arguments: CustomPageRouteArguments(
              transitionType: TransitionType.slideTop,
            ),
          );
          return Future.delayed(const Duration(microseconds: 1));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true, // important!
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height,
                child: Column(
                  children: [
                    FlowTopBar(
                      title: MonthSelector(
                        displayMonthYear: displayedMonth,
                        displayMonthYearSetter: setDisplayedMonth,
                      ),
                    ),
                    FlowSeparatorBox(height: 24),
                    SpendingCalendar(
                      displayedMonth: displayedMonth,
                      onDateSelected: _handleDateTap,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final transactionsAsync = ref.watch(transactionsProvider);
                        
                        return transactionsAsync.when(
                          data: (allTransactions) {
                            // Filter transactions for the displayed month
                            final monthTransactions = allTransactions.where((t) =>
                              t.date.year == displayedMonth.year &&
                              t.date.month == displayedMonth.month
                            ).toList();
                            
                            return Expanded(
                              child: TransactionList(
                                transactions: monthTransactions,
                                detailKeys: _detailKeys,
                              ),
                            );
                          },
                          loading: () => const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, stack) => Expanded(
                            child: Center(child: Text('Error: $error')),
                          ),
                        );
                      },
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
