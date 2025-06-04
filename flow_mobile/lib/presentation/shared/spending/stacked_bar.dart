import 'package:flutter/material.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';

class StackedBar extends StatelessWidget {
  final double total;
  final double height;
  final List<MapEntry<String, dynamic>> entries;

  const StackedBar({
    super.key,
    required this.total,
    required this.height,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Row(
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              final amount = entry.value as double;
              final color = SpendingCategoryUtil.getCategoryColor(entry.key);

              final fraction = total > 0 ? (amount.abs() / total) : 0.0;
              final segmentWidth = constraints.maxWidth * fraction;

              return Container(
                width: segmentWidth,
                decoration: BoxDecoration(
                  color: color,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
