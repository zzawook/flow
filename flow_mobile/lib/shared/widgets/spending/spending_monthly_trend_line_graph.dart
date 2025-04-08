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
    // You can wrap this in any other containers, paddings, or layout widgets.
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
        // Hide or customize grid lines
        gridData: FlGridData(show: false),

        // Hide or customize titles/labels on axes
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // Adjust chart padding if needed
        borderData: FlBorderData(show: false),

        // Pass in lines for green and gray data
        lineBarsData: [
          // Green line
          LineChartBarData(
            // Turn the data list into spots: (index -> x, value -> y)
            spots:
                currentMonthSpendingByDays.asMap().entries.map((entry) {
                  final index = entry.key.toDouble();
                  final value = entry.value;
                  return FlSpot(index, value);
                }).toList(),
            isCurved: true, // curve the line
            color: const Color(0xFF50C878), // line stroke color
            barWidth: 2, // line thickness
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              // Create a vertical gradient from the green color to transparent
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF50C878).withOpacity(0.5),
                  const Color(0xFF50C878).withOpacity(0.0),
                ],
              ),
            ),
          ),
          // Gray line
          LineChartBarData(
            spots:
                lastMonthSpendingByDays.asMap().entries.map((entry) {
                  final index = entry.key.toDouble();
                  final value = entry.value;
                  return FlSpot(index, value);
                }).toList(),
            isCurved: true,
            color: Colors.grey[600], // or any custom gray color
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              // Create a vertical gradient from gray to transparent
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
        ],
      ),
    );
  }
}
