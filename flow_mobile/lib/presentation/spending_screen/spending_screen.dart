import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_card.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_screen/components/fixed_spending_card/fixed_spending_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/special_analysis_card/special_analysis_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/spending_by_category_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/spending_overview_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_trend_card/spending_trend_card.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_main_top_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // Background color
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () {
                Navigator.pushNamed(
                  context,
                  "/refresh",
                  arguments: CustomPageRouteArguments(
                    transitionType: TransitionType.slideTop,
                  ),
                );
                return Future.delayed(const Duration(microseconds: 1));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlowMainTopBar(),
                    const MonthlySpendingOverview(),

                    FlowSeparatorBox(height: 16),

                    const SpendingByCategoryCard(),

                    FlowSeparatorBox(height: 16),

                    const BalanceCard(isOnHomeScreen: false),

                    FlowSeparatorBox(height: 16),

                    FixedSpendingCard(
                      initialMonth: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                    ),

                    FlowSeparatorBox(height: 16),

                    const SpendingTrendCard(),

                    FlowSeparatorBox(height: 16),

                    const SpecialAnalysisCard(),
                  ],
                ),
              ),
            ),
          ),
          FlowBottomNavBar(),
        ],
      ),
    );
  }
}
