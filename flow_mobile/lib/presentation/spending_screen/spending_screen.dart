import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_card.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_screen/components/fixed_spending_card/fixed_spending_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/special_analysis_card/special_analysis_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_by_category_card/spending_by_category_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/spending_overview_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_trend_card/spending_trend_card.dart';
import 'package:flow_mobile/presentation/spending_screen/components/top_spending_cluster_card/top_spending_cluster_card.dart';
import 'package:flow_mobile/presentation/spending_screen/spending_screen_contstants.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_main_top_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    Navigator.pushNamed(
      context,
      SpendingScreenRoutes.refresh,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideTop,
      ),
    );
    await Future.delayed(SpendingScreenStyles.refreshDelay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpendingScreenStyles.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () => _handleRefresh(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpendingScreenStyles.horizontalPadding,
                  vertical: SpendingScreenStyles.verticalPadding,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FlowMainTopBar(),

                    // Monthly overview
                    const MonthlySpendingOverview(),

                    const FlowSeparatorBox(
                      height: SpendingScreenStyles.sectionSpacing,
                    ),

                    // Breakdown by category
                    const SpendingByCategoryCard(),

                    const FlowSeparatorBox(
                      height: SpendingScreenStyles.sectionSpacing,
                    ),

                    // Balance for this month
                    const BalanceCard(isOnHomeScreen: false),

                    const FlowSeparatorBox(
                      height: SpendingScreenStyles.sectionSpacing,
                    ),

                    // Fixed spending section
                    FixedSpendingCard(
                      initialMonth: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                    ),

                    const FlowSeparatorBox(
                      height: SpendingScreenStyles.sectionSpacing,
                    ),

                    // Trend over time
                    SpendingTrendCard(),

                    const FlowSeparatorBox(
                      height: SpendingScreenStyles.sectionSpacing,
                    ),

                    TopSpendingClusterCard(),

                    const FlowSeparatorBox(
                      height: SpendingScreenStyles.sectionSpacing,
                    ),

                    // Any special analyses
                    SpecialAnalysisCard(),
                  ],
                ),
              ),
            ),
          ),
          const FlowBottomNavBar(),
        ],
      ),
    );
  }
}
