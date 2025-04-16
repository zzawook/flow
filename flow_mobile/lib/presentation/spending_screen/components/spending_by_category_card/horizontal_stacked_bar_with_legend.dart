import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/spending_category_legend.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/stacked_bar.dart';
import 'package:flutter/widgets.dart';

class HorizontalStackedBarWithLegend extends StatelessWidget {
  final Map<String, dynamic> categories;

  const HorizontalStackedBarWithLegend({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final double total =
        categories.values.fold(0.0, (double sum, dynamic item) {
          return sum + item;
        }).abs();

    // Convert entries to a list so we can access by index
    final entries = categories.entries.toList();

    // Sort entries by value
    entries.sort((a, b) => a.value.compareTo(b.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The stacked bar
        StackedBar(total: total, entries: entries),
        const SizedBox(height: 16),
        // The legend
        CategoryLegend(entries: entries),
      ],
    );
  }
}
