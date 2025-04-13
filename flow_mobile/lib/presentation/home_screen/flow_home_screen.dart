import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/home_screen/components/accounts_card/account_card.dart';
import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_card.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flow_mobile/presentation/home_screen/components/quick_transfer_card/quick_transfer_card.dart';
import 'package:flutter/material.dart';

/// The main screen that holds state and composes smaller widgets.
class FlowHomeScreen extends StatefulWidget {
  const FlowHomeScreen({super.key});

  @override
  _FlowHomeScreenState createState() => _FlowHomeScreenState();
}

class _FlowHomeScreenState extends State<FlowHomeScreen> {
  // Example state: toggling the visibility of the balance
  bool _showBalance = false;

  // Example callback to toggle balance
  void _toggleBalance() {
    setState(() {
      _showBalance = !_showBalance;
    });
  }

  // Example callback to handle notifications
  void _handleNotificationTap() {
    // Implement your logic here
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
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
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    right: 18,
                    top: 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      FlowTopBar(onNotificationTap: _handleNotificationTap),

                      // Accounts Section
                      AccountsCard(onToggleBalance: _toggleBalance),

                      // Quick Transfer Section
                      QuickTransferCard(),

                      // Balance Section
                      BalanceCard(showBalance: _showBalance),
                    ],
                  ),
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
