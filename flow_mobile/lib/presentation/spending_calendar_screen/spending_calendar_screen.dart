import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
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

class _SpendingDetailScreenState extends State<SpendingCalendarScreen>
    with TickerProviderStateMixin {
  late DateTime displayedMonth;
  final Map<DateTime, GlobalKey> _detailKeys = {};

  late final AnimationController _calCtrl;
  late final Animation<double> _calFactor; // 0 (collapsed) -> 1 (expanded)

  bool get _calendarExpanded => _calCtrl.value > 0.5;

  @override
  void initState() {
    super.initState();
    displayedMonth = widget.displayedMonth;
    _initDetailKeys();

    _calCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      value: 1.0, // start expanded
    );
    _calFactor = CurvedAnimation(parent: _calCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _calCtrl.dispose();
    super.dispose();
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

  void onToggleCalendarPressed() {
    if (_calendarExpanded) {
      _calCtrl.reverse(); // collapse
    } else {
      _calCtrl.forward(); // expand
    }
  }

  Widget _buildShowHideCalendarIcon(
    BuildContext context,
    bool calendarExpanded,
  ) {
    final darkIconColor = Color.fromARGB(255, 255, 255, 255);
    final lightIconColor = Color.fromARGB(255, 0, 0, 0);

    final showColor = Theme.of(context).brightness == Brightness.dark
        ? darkIconColor
        : lightIconColor;
    final hideColor = Theme.of(context).brightness == Brightness.dark
        ? darkIconColor.withValues(alpha: 0.5)
        : lightIconColor.withValues(alpha: 0.5);
    return FlowButton(
      onPressed: onToggleCalendarPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: calendarExpanded ? hideColor : hideColor,
          ),
          Icon(
            Icons.close,
            size: 36,
            color: calendarExpanded
                ? hideColor.withValues(alpha: 0.4)
                : showColor.withValues(alpha: 0),
          ),
        ],
      ),
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
                      leftWidget: AnimatedBuilder(
                        animation: _calCtrl,
                        builder: (context, _) => _buildShowHideCalendarIcon(
                          context,
                          _calendarExpanded, // uses _calCtrl.value > 0.5
                        ),
                      ),
                    ),
                    FlowSeparatorBox(height: 24),
                    ClipRect(
                      child: FadeTransition(
                        // optional: also fade in/out
                        opacity: _calFactor,
                        child: SizeTransition(
                          sizeFactor: _calFactor, // 0..1 height
                          axisAlignment: -1.0, // collapse from the top edge
                          child: SpendingCalendar(
                            displayedMonth: displayedMonth,
                            onDateSelected: _handleDateTap,
                          ),
                        ),
                      ),
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
