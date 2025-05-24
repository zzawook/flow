import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/utils/recurring_spending.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/shared/widgets/month_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The details screen
class FixedSpendingDetailsScreen extends StatefulWidget {
  final DateTime month;

  const FixedSpendingDetailsScreen({super.key, required this.month});

  @override
  State<FixedSpendingDetailsScreen> createState() =>
      _FixedSpendingDetailsScreenState();
}

class _FixedSpendingDetailsScreenState
    extends State<FixedSpendingDetailsScreen> {
  final Map<FixedSpendingCategory, List<SpendingItem>> data = {
    FixedSpendingCategory.telco: [
      SpendingItem(
        amount: 10,
        subtitle: "SKT",
        scheduledDay: 5,
        icon: Icons.phone_android,
      ),
      SpendingItem(
        amount: 20,
        subtitle: "LG U+",
        scheduledDay: 10,
        icon: Icons.phone_iphone,
      ),
    ],
    FixedSpendingCategory.subscription: [
      SpendingItem(
        amount: 15,
        subtitle: "Netflix",
        scheduledDay: 15,
        icon: Icons.tv,
      ),
    ],
    FixedSpendingCategory.utilities: [
      SpendingItem(
        amount: 50,
        subtitle: "Electricity",
        scheduledDay: 20,
        icon: Icons.lightbulb,
      ),
      SpendingItem(
        amount: 30,
        subtitle: "Water",
        scheduledDay: 25,
        icon: Icons.water_drop,
      ),
      SpendingItem(
        amount: 7,
        subtitle: "Gas",
        scheduledDay: 30,
        icon: Icons.fireplace,
      ),
    ],
    FixedSpendingCategory.insurance: [
      SpendingItem(
        amount: 250,
        subtitle: "Health Insurance",
        scheduledDay: 28,
        icon: Icons.health_and_safety,
      ),
    ],
    FixedSpendingCategory.rent: [
      SpendingItem(
        amount: 1550,
        subtitle: "Monthly Rent",
        scheduledDay: 1,
        icon: Icons.home,
      ),
    ],
    FixedSpendingCategory.others: [
      SpendingItem(
        amount: 78,
        subtitle: "AWS Subscription",
        scheduledDay: 15,
        icon: Icons.more_horiz,
      ),
    ],
    FixedSpendingCategory.installment: [
      SpendingItem(
        amount: 200,
        subtitle: "Car Loan",
        scheduledDay: 10,
        icon: Icons.credit_card,
      ),
      SpendingItem(
        amount: 150,
        subtitle: "Phone Installment",
        scheduledDay: 20,
        icon: Icons.phone_iphone,
      ),
    ],
  };

  late DateTime month;

  @override
  void initState() {
    super.initState();
    month = widget.month;
  }

  String _formatKRW(int amount) {
    final f = NumberFormat.currency(
      locale: 'en_SG',
      symbol: "\$ ",
      decimalDigits: 0,
    );
    return f.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final double total = data.values
        .expand((items) => items)
        .fold(0, (sum, item) => sum + item.amount);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              FixedSpendingTopBar(
                month: month,
                onMonthChange: (newMonth) {
                  setState(() {
                    month = newMonth;
                  });
                },
              ),

              FlowSeparatorBox(height: 45),

              Text(
                "Fixed Spending",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color(0x88000000),
                ),
              ),

              Text(
                "\$ $total",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF50C878),
                ),
              ),

              FlowSeparatorBox(height: 36),

              Expanded(
                child: ListView(
                  children:
                      FixedSpendingCategory.values.map((cat) {
                        final items = data[cat] ?? [];
                        final total = items.fold<int>(
                          0,
                          (sum, i) => sum + i.amount,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section header
                            Row(
                              children: [
                                Text(
                                  cat.label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _formatKRW(total),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            ...items.map((item) {
                              String dateText = '';
                              if (item.scheduledDay > DateTime.now().day &&
                                  month.month == DateTime.now().month) {
                                dateText = 'Scheduled for';
                              } else {
                                dateText = 'Complete on';
                              }
                              return ListTile(
                                leading: cat.icon,
                                title: Text(
                                  _formatKRW(item.amount),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0x88000000),
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          dateText,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0x66000000),
                                          ),
                                        ),
                                        Text(
                                          ' ${item.scheduledDay}${DateTimeUtil.getDatePostFix(item.scheduledDay)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0x66000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // Actual items
                            const FlowSeparatorBox(height: 30),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FixedSpendingTopBar extends StatelessWidget {
  final DateTime month;
  final Function(DateTime) onMonthChange;

  const FixedSpendingTopBar({
    super.key,
    required this.month,
    required this.onMonthChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlowButton(
          child: Image.asset(
            'assets/icons/previous.png',
            height: 20,
            width: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonthSelector(
                displayMonthYear: month,
                displayMonthYearSetter: onMonthChange,
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}

/// A single recurring‐payment entry
class SpendingItem {
  final int amount;
  final String subtitle;
  final int scheduledDay;
  final IconData icon;

  SpendingItem({
    required this.amount,
    required this.subtitle,
    required this.scheduledDay,
    required this.icon,
  });
}
