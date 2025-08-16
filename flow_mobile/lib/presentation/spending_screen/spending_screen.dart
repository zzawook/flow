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
import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_main_top_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/flow_top_bar.dart';

class SpendingScreen extends ConsumerStatefulWidget {
  const SpendingScreen({super.key});

  @override
  ConsumerState<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends ConsumerState<SpendingScreen> {
  static const _fadeStart = 75.0; // begin to appear
  static const _fadeEnd = 100.0; // fully visible

  final _scrollController = ScrollController();
  double _barOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    final newOpacity = switch (offset) {
      <= _fadeStart => 0.0,
      >= _fadeEnd => 1.0,
      _ => (offset - _fadeStart) / (_fadeEnd - _fadeStart),
    };

    if (newOpacity != _barOpacity) {
      setState(() => _barOpacity = newOpacity);
    }
  }

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
    return FlowSafeArea(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          /* ---------- MAIN PAGE CONTENT ---------- */
          Column(
            children: [
              Expanded(
                child: RefreshIndicator.adaptive(
                  onRefresh: () => _handleRefresh(context),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpendingScreenStyles.horizontalPadding,
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

          /* ---------- FADING TOP BAR OVERLAY ---------- */
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _barOpacity,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: _barOpacity == 0,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: FlowTopBar(
                    showBackButton: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final displayedMonth = ref.watch(spendingScreenStateProvider).displayedMonth;
                            return MonthSelector(
                              displayMonthYear: displayedMonth,
                              displayMonthYearSetter: (newMonth) {
                                ref.read(spendingScreenNotifierProvider.notifier)
                                    .updateDisplayedMonth(newMonth);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
