import 'package:flow_mobile/presentation/home_screen/components/accounts_card/account_card.dart';
import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_card.dart';
import 'package:flow_mobile/common/flow_top_bar.dart';
import 'package:flow_mobile/presentation/home_screen/components/quick_transfer_card/quick_transfer_card.dart';
import 'package:flutter/widgets.dart';

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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
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
    );
  }
}
