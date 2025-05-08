import 'package:flow_mobile/shared/utils/spending_category_util.dart';
import 'package:flutter/material.dart';

class StackedBar extends StatelessWidget {
  final double total;
  final List<MapEntry<String, dynamic>> entries;

  const StackedBar({super.key, required this.total, required this.entries});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              final amount = entry.value;
              final color = SpendingCategoryUtil.getCategoryColor(entry.key);

              // Calculate width for this segment
              final fraction = total > 0 ? (amount.abs() / total) : 0.0;
              final segmentWidth = constraints.maxWidth * fraction;

              // Determine border radius for first and last segments
              BorderRadius borderRadius;
              if (entries.length == 1) {
                // Only one segment, round all corners
                borderRadius = BorderRadius.circular(10);
              } else if (index == 0) {
                // First segment: round the left side
                borderRadius = const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                );
              } else if (index == entries.length - 1) {
                // Last segment: round the right side
                borderRadius = const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                );
              } else {
                borderRadius = BorderRadius.zero;
              }

              return Container(
                width: segmentWidth,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: borderRadius,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
