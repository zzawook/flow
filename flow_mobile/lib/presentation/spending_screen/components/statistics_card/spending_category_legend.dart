import 'package:flow_mobile/shared/utils/spending_category_util.dart';
import 'package:flutter/widgets.dart';

class CategoryLegend extends StatelessWidget {
  final List<MapEntry<String, dynamic>> entries;

  const CategoryLegend({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children:
          entries.map((entry) {
            final colorHex = SpendingCategoryUtil.getCategoryColor(entry.key);
            final color = _parseColor(colorHex);
            final categoryName = entry.key; // e.g. "transfer", "food", etc.

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  capitalize(categoryName),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  Color _parseColor(String hexColor) {
    String colorString = hexColor.replaceAll('#', '');
    if (colorString.length == 6) {
      colorString = 'FF$colorString';
    }
    return Color(int.parse(colorString, radix: 16));
  }
}
