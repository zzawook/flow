import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/spending_calendar.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/spending_calendar_screen_top_bar.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingCalendarScreen extends StatefulWidget {
  final DateTime displayedMonth;
  const SpendingCalendarScreen({super.key, required this.displayedMonth});

  @override
  SpendingDetailScreenState createState() => SpendingDetailScreenState();
}

class SpendingDetailScreenState extends State<SpendingCalendarScreen> {
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    displayedMonth = widget.displayedMonth;
  }

  void setDisplayedMonth(DateTime month) {
    setState(() {
      displayedMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // A simple container to hold the entire screen
    return RefreshIndicator(
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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Container(
            color: const Color(0xFFF5F5F5),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 72),
              child: Column(
                children: [
                  SpendingCalendarScreenTopBar(
                    displayMonthYear: displayedMonth,
                    displayMonthYearSetter: setDisplayedMonth,
                  ),
                  FlowSeparatorBox(height: 24),
                  SpendingCalendar(displayedMonth: displayedMonth),
                  StoreConnector<FlowState, List<Transaction>>(
                    converter:
                        (store) => store.state.transactionState
                            .getTransactionsForMonth(displayedMonth),
                    builder:
                        (
                          BuildContext context,
                          List<Transaction> transactions,
                        ) => Expanded(
                          child: TransactionList(transactions: transactions),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
