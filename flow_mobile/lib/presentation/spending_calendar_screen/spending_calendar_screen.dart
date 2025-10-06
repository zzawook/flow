import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/spending_calendar.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingCalendarScreen extends StatefulWidget {
  final DateTime displayedMonth;
  const SpendingCalendarScreen({super.key, required this.displayedMonth});

  @override
  State<SpendingCalendarScreen> createState() => _SpendingDetailScreenState();
}

class _SpendingDetailScreenState extends State<SpendingCalendarScreen> {
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
      backgroundColor: Theme.of(context).cardColor,
      child: RefreshIndicator.adaptive(
        color: Theme.of(context).primaryColor,
        onRefresh: () {
          Navigator.pushNamed(
            context,
            AppRoutes.refresh,
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
                    StoreConnector<FlowState, List<Transaction>>(
                      converter: (store) => store.state.transactionState
                          .getTransactionsForMonth(displayedMonth),
                      builder: (context, transactions) => Expanded(
                        child: TransactionList(
                          transactions: transactions,
                          detailKeys: _detailKeys,
                        ),
                      ),
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
