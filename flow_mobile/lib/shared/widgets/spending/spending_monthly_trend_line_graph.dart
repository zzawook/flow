import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingMonthlyTrendLineGraph extends StatelessWidget {
  final List<double> currentMonthSpendingByDays;
  final List<double> lastMonthSpendingByDays;
  final double width;
  final double height;
  final bool enableTooltip;

  const SpendingMonthlyTrendLineGraph({
    super.key,
    required this.currentMonthSpendingByDays,
    required this.lastMonthSpendingByDays,
    required this.width,
    required this.height,
    required this.enableTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SpendingMonthlyTrendLineGraphContent(
        currentMonthSpendingByDays: currentMonthSpendingByDays,
        lastMonthSpendingByDays: lastMonthSpendingByDays,
        enableTooltip: enableTooltip,
      ),
    );
  }
}

class SpendingMonthlyTrendLineGraphContent extends StatelessWidget {
  final List<double> currentMonthSpendingByDays;
  final List<double> lastMonthSpendingByDays;
  final bool enableTooltip;

  const SpendingMonthlyTrendLineGraphContent({
    super.key,
    required this.currentMonthSpendingByDays,
    required this.lastMonthSpendingByDays,
    required this.enableTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // 1) Enable touch interactions & configure the tooltip
        lineTouchData: LineTouchData(
          enabled: enableTooltip,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) {
              // final index = touchedSpot.x.toInt();
              // final isCurrentMonth = currentMonthSpendingByDays[index] != 0;
              return Color(0x22000000);
            },
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItems: (spots) {
              if (spots.isEmpty) {
                return [];
              }
              if (spots.length == 1) {
                return [
                  LineTooltipItem(
                    spots[0].y.toStringAsFixed(2),
                    TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ];
              }

              String currentMonthValue = "";
              String lastMonthValue = "";

              if (spots[0].y == lastMonthSpendingByDays[spots[0].x.toInt()]) {
                currentMonthValue = spots[1].y.toStringAsFixed(2);
                lastMonthValue = spots[0].y.toStringAsFixed(2);
              } else {
                currentMonthValue = spots[0].y.toStringAsFixed(2);
                lastMonthValue = spots[1].y.toStringAsFixed(2);
              }

              return [
                LineTooltipItem(
                  currentMonthValue,
                  TextStyle(
                    color: Color(0xFF50C878),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                LineTooltipItem(
                  lastMonthValue,
                  TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ];
            },
          ),
        ),

        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          // Gray line (last month)
          LineChartBarData(
            spots:
                lastMonthSpendingByDays
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
            isCurved: true,
            color: Colors.grey[600],
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.5),
                  Colors.grey.withOpacity(0.0),
                ],
              ),
            ),
          ),

          // Green line (current month)
          LineChartBarData(
            spots:
                currentMonthSpendingByDays
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
            isCurved: true,
            color: const Color(0xFF50C878),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                if (index == barData.spots.length - 1) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: barData.color!,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(radius: 0);
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF50C878).withOpacity(0.4),
                  const Color(0xFF50C878).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
