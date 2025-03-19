import 'package:flutter/material.dart';

class StackedBar extends StatelessWidget {
  final Map<String, dynamic> categories;

  const StackedBar({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Calculate total amount
    final double total = categories.values.fold(0.0, (
      double sum,
      dynamic item,
    ) {
      return sum + (item['amount'] as num).toDouble();
    });

    // Convert entries to a list so we can access by index
    final entries = categories.entries.toList();

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
              final amount = (entry.value['amount'] as num).toDouble();
              final colorHex = entry.value['color'] as String;
              final color = _parseColor(colorHex);

              // Calculate width for this segment
              final fraction = total > 0 ? (amount / total) : 0.0;
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

  // Helper method to parse a hex color like "#8BC34A" into a Flutter Color
  Color _parseColor(String hexColor) {
    String colorString = hexColor.replaceAll('#', '');
    if (colorString.length == 6) {
      colorString = 'FF$colorString'; // Add alpha if not present
    }
    return Color(int.parse(colorString, radix: 16));
  }
}
