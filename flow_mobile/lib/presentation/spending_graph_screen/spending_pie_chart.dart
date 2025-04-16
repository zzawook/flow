import 'package:fl_chart/fl_chart.dart';
import 'package:flow_mobile/shared/utils/spending_category_util.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';

class SpendingPieChart extends StatelessWidget {
  final List<MapEntry<String, double>> sortedCategories;
  final double radius;
  const SpendingPieChart({
    super.key,
    required this.sortedCategories,
    required this.radius,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PieChartSections(sortedCategories: sortedCategories, radius: radius),
        const FlowSeparatorBox(height: 24),
        SpendingList(sortedCategories: sortedCategories),
      ],
    );
  }
}

/// This widget encapsulates the pie chart data and returns the PieChart widget.
class PieChartSections extends StatelessWidget {
  final double radius;
  PieChartSections({
    super.key,
    required this.sortedCategories,
    required this.radius,
  });

  final List<MapEntry<String, double>> sortedCategories;
  final TextStyle titleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  final titlePositionPercentageOffset = 0.75;
  final badgePositionPercentageOffset = 1.15;

  /// Returns a list of pie chart sections.
  List<PieChartSectionData> _buildSections() {
    // Sort categories by value

    final total = sortedCategories.fold(0.0, (
      double sum,
      MapEntry<String, double> entry,
    ) {
      return sum + entry.value;
    });

    // Create pie chart sections
    List<PieChartSectionData> sections = [];
    for (var entry in sortedCategories) {
      sections.add(
        PieChartSectionData(
          value: entry.value.abs(),
          color: Color(
            int.parse(
              SpendingCategoryUtil.getCategoryColor(
                entry.key,
              ).replaceFirst("#", "0xFF"),
            ),
          ),
          title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: titleStyle,
          titlePositionPercentageOffset: titlePositionPercentageOffset,
          badgeWidget: Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(
                int.parse(
                  SpendingCategoryUtil.getCategoryColor(
                    entry.key,
                  ).replaceFirst("#", "0x88"),
                ),
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(SpendingCategoryUtil.getCategoryIcon(entry.key)),
          ),
          badgePositionPercentageOffset: badgePositionPercentageOffset,
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (radius * 2),
      height: (radius * 2),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 0,
          sections: _buildSections(),
        ),
      ),
    );
  }
}

class SpendingList extends StatelessWidget {
  final List<MapEntry<String, dynamic>> sortedCategories;

  const SpendingList({super.key, required this.sortedCategories});

  @override
  Widget build(BuildContext context) {
    final total = sortedCategories.fold(0.0, (double sum, entry) {
      return sum + entry.value.abs();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        ...sortedCategories.map((entry) {
          final percentage = (entry.value.abs() / total * 100);
          return Container(
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 35,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const FlowSeparatorBox(width: 8),
                  Container(
                    width: 42,
                    height: 42,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(
                          SpendingCategoryUtil.getCategoryColor(
                            entry.key,
                          ).replaceFirst("#", "0xFF"),
                        ),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      SpendingCategoryUtil.getCategoryIcon(entry.key),
                    ),
                  ),
                  const FlowSeparatorBox(width: 8),
                  // Wrap the Column with Expanded to constrain its width.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '\$ ${entry.value.abs().toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                        const FlowSeparatorBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: PercentageBar(
                                percentage: percentage,
                                color: Color(
                                  int.parse(
                                    SpendingCategoryUtil.getCategoryColor(
                                      entry.key,
                                    ).replaceFirst("#", "0xFF"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class PercentageBar extends StatelessWidget {
  final double percentage;
  final Color color;

  const PercentageBar({
    super.key,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(7),
      ),
      child: FractionallySizedBox(
        widthFactor: percentage / 100,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
