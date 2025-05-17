import 'package:flow_mobile/presentation/home_screen/components/accounts_card/account_card.dart';
import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_card.dart';
import 'package:flow_mobile/presentation/home_screen/components/quick_transfer_card/quick_transfer_card.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_main_top_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlowHomeScreen extends StatefulWidget {
  const FlowHomeScreen({super.key});

  @override
  _FlowHomeScreenState createState() => _FlowHomeScreenState();
}

class _FlowHomeScreenState extends State<FlowHomeScreen> {
  bool _showBalance = false;
  bool _backPressed = false;

  final int BACKPRESS_HOLD_DURATION = 2;

  void _toggleBalance() {
    setState(() {
      _showBalance = !_showBalance;
    });
  }

  void _onBackPressed() {
    if (_backPressed) {
      // second press → actually pop
      SystemNavigator.pop();
    } else {
      // first press → show “toast” via SnackBar
      _backPressed = true;
      ScaffoldMessenger.of(context).showSnackBar(
        FlowSnackbar(
          content: Text(
            "Press again to exit",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          duration: 2,
        ).build(context),
      );
      // reset after 2s
      Future.delayed(Duration(seconds: BACKPRESS_HOLD_DURATION), () {
        _backPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
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
                  return Future.delayed(const Duration(milliseconds: 100));
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
                        FlowMainTopBar(),
                        AccountsCard(onToggleBalance: _toggleBalance),
                        QuickTransferCard(),
                        BalanceCard(isOnHomeScreen: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FlowBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
