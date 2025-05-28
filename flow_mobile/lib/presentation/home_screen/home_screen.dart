import 'dart:async';

import 'package:flow_mobile/presentation/home_screen/components/accounts_card/accounts_card.dart';
import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_card.dart';
import 'package:flow_mobile/presentation/home_screen/components/quick_transfer_card/quick_transfer_card.dart';
import 'package:flow_mobile/presentation/home_screen/home_screen_constants.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_main_top_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlowHomeScreen extends StatefulWidget {
  const FlowHomeScreen({super.key});

  @override
  State<FlowHomeScreen> createState() => _FlowHomeScreenState();
}

class _FlowHomeScreenState extends State<FlowHomeScreen> {
  bool _backPressed = false;
  static const _backPressDuration = Duration(seconds: 2);

  void _onToggleBalance() {
    // forward to BalanceCard via Redux or callback, if needed
  }

  void _handleBack() {
    if (_backPressed) {
      SystemNavigator.pop();
    } else {
      _backPressed = true;
      ScaffoldMessenger.of(context).showSnackBar(
        FlowSnackbar(
          content: const Text(
            'Press again to exit',
            style: HomeScreenTextStyles.snackBar,
          ),
          duration: 2,
        ).build(context),
      );
      Timer(_backPressDuration, () => _backPressed = false);
    }
  }

  Future<void> _onRefresh() async {
    Navigator.pushNamed(
      context,
      HomeScreenRoutes.refresh,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideTop,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _handleBack();
      },
      child: FlowSafeArea(
        backgroundColor: themeData.canvasColor,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator.adaptive(
                color: themeData.primaryColor,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false, // important!
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FlowMainTopBar(),
                            AccountsCard(onToggleBalance: _onToggleBalance),
                            const QuickTransferCard(),
                            const BalanceCard(isOnHomeScreen: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const FlowBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
