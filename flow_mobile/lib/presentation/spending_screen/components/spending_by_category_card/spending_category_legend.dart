import 'package:flow_mobile/utils/spending_category_util.dart';
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
            final color = SpendingCategoryUtil.getCategoryColor(entry.key);
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
}
