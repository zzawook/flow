import 'package:flow_mobile/common/flow_top_bar.dart';
import 'package:flow_mobile/common/flow_separator_box.dart';
import 'package:flow_mobile/screens/spending_screen/components/spending_overview_card/spending_overview_card.dart';
import 'package:flow_mobile/screens/spending_screen/components/special_analysis_card/special_analysis_card.dart';
import 'package:flow_mobile/screens/spending_screen/components/statistics_card/statistics_card.dart';
import 'package:flutter/widgets.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({super.key});

  @override
  _SpendingScreenState createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  void _handleNotificationTap() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // Background color
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlowTopBar(onNotificationTap: _handleNotificationTap),
            const MonthlySpendingOverview(),

            FlowSeparatorBox(height: 16),

            const StatisticsCard(),

            FlowSeparatorBox(height: 16),

            const SpecialAnalysisCard(),
          ],
        ),
      ),
    );
  }
}
