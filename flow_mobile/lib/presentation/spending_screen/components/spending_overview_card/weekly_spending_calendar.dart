import 'package:flow_mobile/domain/models/weekly_spending_data.dart';
import 'package:flow_mobile/domain/redux/actions/spending_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class WeeklySpendingCalendar extends StatefulWidget {
  const WeeklySpendingCalendar({super.key});

  @override
  _WeeklySpendingCalendarState createState() => _WeeklySpendingCalendarState();
}

class _WeeklySpendingCalendarState extends State<WeeklySpendingCalendar> {
  static const int _initialPage = 1000;
  late final PageController _pageController;
  late final DateTime _initialMonday;
  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialMonday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).subtract(Duration(days: DateTime.now().weekday - DateTime.monday));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _startOfWeek(DateTime dt) {
    return dt.subtract(Duration(days: dt.weekday - DateTime.monday));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, _ViewModel>(
      distinct: true,
      converter: (store) {
        final s = store.state.screenState.spendingScreenState;
        return _ViewModel(
          selectedDate: s.selectedDate,
          displayWeek: s.weeklySpendingCalendarDisplayWeek,
        );
      },
      builder: (context, vm) {
        final today = DateTime.now();

        // compute desired page for current displayWeek
        final newMonday = _startOfWeek(vm.displayWeek);
        final weekDelta = newMonday.difference(_initialMonday).inDays ~/ 7;
        final targetPage = _initialPage + weekDelta;

        if (targetPage != _currentPage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _pageController.jumpToPage(targetPage);
          });
          _currentPage = targetPage;
        }

        return SizedBox(
          height: 140,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _initialPage + 1,
            onPageChanged: (page) {
              final delta = page - _initialPage;
              final updatedMonday = _initialMonday.add(
                Duration(days: delta * 7),
              );
              StoreProvider.of<FlowState>(context, listen: false).dispatch(
                SetWeeklySpendingCalendarDisplayWeekAction(updatedMonday),
              );
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, page) {
              final delta = page - _initialPage;
              final monday = _initialMonday.add(Duration(days: delta * 7));
              return _buildWeekRow(context, monday, today, vm.selectedDate);
            },
          ),
        );
      },
    );
  }

  Widget _buildWeekRow(
    BuildContext context,
    DateTime monday,
    DateTime today,
    DateTime selectedDate,
  ) {
    final sunday = monday.add(const Duration(days: 6));
    final txState =
        StoreProvider.of<FlowState>(
          context,
          listen: false,
        ).state.transactionState;
    final txns = txState.getTransactionsFromTo(monday, sunday);

    final data = WeeklySpendingData(monday);
    for (final tx in txns) {
      data.addTransaction(tx);
    }
    final weeklyData = data.getWeeklySpendingData();

    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    return StoreConnector<FlowState, DateTime>(
      distinct: true,
      converter:
          (store) => store.state.screenState.spendingScreenState.displayedMonth,
      builder:
          (context, displayMonth) => Container(
            padding: const EdgeInsets.only(top: 20, bottom: 18),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  days.map((dateTime) {
                    final item =
                        weeklyData[dateTime] ?? {'income': 0.0, 'expense': 0.0};

                    final income = item['income']!;
                    final expense = item['expense']!;
                    final isToday = _isSameDay(dateTime, today);
                    final isSelected = _isSameDay(dateTime, selectedDate);
                    final dayName = DateFormat('EEE').format(dateTime);
                    final dateNumber = dateTime.day;
                    final incomeText =
                        income != 0 ? '+${income.toStringAsFixed(2)}' : '';
                    final expenseText =
                        expense != 0
                            ? '-${expense.abs().toStringAsFixed(2)}'
                            : '';

                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(dayName, style: const TextStyle(fontSize: 12)),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (dateTime.isAfter(today)) return;
                              StoreProvider.of<FlowState>(
                                context,
                                listen: false,
                              ).dispatch(SetSelectedDateAction(dateTime));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration:
                                  isToday
                                      ? const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0x16000000),
                                      )
                                      : isSelected
                                      ? const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0x6450C878),
                                      )
                                      : null,
                              child: Text(
                                '$dateNumber',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      _shouldDimDate(dateTime, displayMonth)
                                          ? const Color(0xFFB0B0B0)
                                          : const Color(0xFF000000),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            expense != 0 && income == 0
                                ? expenseText
                                : incomeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color:
                                  (expense != 0 && income == 0)
                                      ? const Color(0x75000000)
                                      : const Color(0xFF50C878),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            income != 0 ? expenseText : "",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Color(0x75000000),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _shouldDimDate(DateTime date, DateTime displayMonth) {
    if (date.isAfter(DateTime.now())) {
      return true;
    } else if (date.month != displayMonth.month ||
        date.year != displayMonth.year) {
      return true;
    }
    return false;
  }
}

// simple view model for the connector
class _ViewModel {
  final DateTime selectedDate;
  final DateTime displayWeek;
  _ViewModel({required this.selectedDate, required this.displayWeek});
}
