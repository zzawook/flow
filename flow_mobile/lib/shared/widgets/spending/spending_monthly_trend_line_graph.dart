import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingMonthlyTrendLineGraph extends StatelessWidget {
  final List<double> currentMonthSpendingByDays;
  final List<double> lastMonthSpendingByDays;
  final double width;
  final double height;

  const SpendingMonthlyTrendLineGraph({
    super.key,
    required this.currentMonthSpendingByDays,
    required this.lastMonthSpendingByDays,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SpendingMonthlyTrendLineGraphContent(
        currentMonthSpendingByDays: currentMonthSpendingByDays,
        lastMonthSpendingByDays: lastMonthSpendingByDays,
      ),
    );
  }
}

class SpendingMonthlyTrendLineGraphContent extends StatelessWidget {
  final List<double> currentMonthSpendingByDays;
  final List<double> lastMonthSpendingByDays;

  const SpendingMonthlyTrendLineGraphContent({
    super.key,
    required this.currentMonthSpendingByDays,
    required this.lastMonthSpendingByDays,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
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
                lastMonthSpendingByDays.asMap().entries.map((entry) {
                  final index = entry.key.toDouble();
                  final value = entry.value;
                  return FlSpot(index, value);
                }).toList(),
            isCurved: true,
            color: Colors.grey[600],
            // 1) Make line thicker
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
                currentMonthSpendingByDays.asMap().entries.map((entry) {
                  final index = entry.key.toDouble();
                  final value = entry.value;
                  return FlSpot(index, value);
                }).toList(),
            isCurved: true,
            color: const Color(0xFF50C878),
            // 1) Make line thicker
            barWidth: 3,
            // 2) Show a circular indicator only on the final spot
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Show a dot painter only for the last spot
                if (index == barData.spots.length - 1) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: barData.color ?? const Color(0xFF50C878),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                }
                // Hide (or make transparent) dots for other spots
                return FlDotCirclePainter(radius: 0);
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF50C878).withOpacity(1.0),
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
