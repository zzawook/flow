import 'package:flow_mobile/presentation/spending_screen/components/statistics_card/spending_category_legend.dart';
import 'package:flow_mobile/presentation/spending_screen/components/statistics_card/stacked_bar.dart';
import 'package:flutter/widgets.dart';

class HorizontalStackedBarWithLegend extends StatelessWidget {
  final Map<String, dynamic> categories;

  const HorizontalStackedBarWithLegend({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The stacked bar
        StackedBar(categories: categories),
        const SizedBox(height: 16),
        // The legend
        CategoryLegend(categories: categories),
      ],
    );
  }
}
