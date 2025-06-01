import 'package:flow_mobile/presentation/asset_screen/components/total_asset_card/monthly_asset_bar_chart.dart';
import 'package:flutter/material.dart';

class TotalAssetCard extends StatefulWidget {
  const TotalAssetCard({super.key});

  @override
  State<TotalAssetCard> createState() => _TotalAssetCardState();
}

class _TotalAssetCardState extends State<TotalAssetCard> {
  Map<DateTime, double> last6MonthlyAssetData = {
    DateTime.now(): 719.2,
    DateTime(DateTime.now().year, DateTime.now().month, 0):
        1219.0, // Last day of previous month
    DateTime(DateTime.now().year, DateTime.now().month - 1, 0):
        899.1, // Last day of 2 months ago
    DateTime(DateTime.now().year, DateTime.now().month - 2, 0):
        1512.9, // Last day of 3 months ago
    DateTime(DateTime.now().year, DateTime.now().month - 3, 0):
        901.9, // Last day of 4 months ago
    DateTime(DateTime.now().year, DateTime.now().month - 4, 0):
        1109.5, // Last day of 5 months ago
  };

  Widget getCurrentMonthStatusComparedToLastMonthMessage() {
    final currentMonth = DateTime.now();
    final lastMonth = DateTime(currentMonth.year, currentMonth.month - 1, 0);
    final currentMonthAmount = last6MonthlyAssetData[currentMonth] ?? 0.0;
    final lastMonthAmount = last6MonthlyAssetData[lastMonth] ?? 0.0;

    Widget message = Row(
      children: [
        Text(
          "\$ ${(currentMonthAmount - lastMonthAmount).abs().toStringAsFixed(2)} ${currentMonthAmount > lastMonthAmount ? "more" : "less"}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                currentMonthAmount < lastMonthAmount
                    ? Colors.red
                    : Theme.of(context).primaryColor,
          ),
        ),
        Text(
          " than last month",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for total asset display
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Assets',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                getCurrentMonthStatusComparedToLastMonthMessage(),
              ],
            ),
          ),
          // Placeholder for asset amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            height: 300,
            child: MonthlyAssetBarChart(
              last6MonthlyAssetData: last6MonthlyAssetData,
              normalBarColor:
                  Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFCACACA)
                      : const Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }
}
