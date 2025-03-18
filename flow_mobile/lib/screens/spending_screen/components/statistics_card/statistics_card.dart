import 'package:flow_mobile/common/flow_button.dart';
import 'package:flow_mobile/common/flow_separator_box.dart';
import 'package:flow_mobile/screens/spending_screen/components/statistics_card/horizontal_stacked_bar_with_legend.dart';
import 'package:flutter/material.dart';

/// Statistics Section
class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key});

  static const categories = {
    "transfer": {"amount": 2000, "color": "#8BC34A"},
    "transportation": {"amount": 300, "color": "#FF9800"},
    "food": {"amount": 900, "color": "#F44336"},
    "others": {"amount": 534.35, "color": "#9E9E9E"},
    "somecaregory": {"amount": 100, "color": "#2196F3"},
  };

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'January ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                Text(
                  'statistics',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            FlowSeparatorBox(height: 8),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$ 3734.35',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C864),
                    ),
                  ),
                ],
              ),
            ),
            FlowSeparatorBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: HorizontalStackedBarWithLegend(categories: categories),
            ),
            FlowSeparatorBox(height: 8),
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 24, right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View charts ',
                    style: TextStyle(color: Color(0xFFA6A6A6), fontSize: 18),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    child: Image.asset(
                      'assets/icons/vector.png',
                      width: 12,
                      height: 12,
                      color: Color(0xFFA19F9F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
