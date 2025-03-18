/* -------------------------------------------------------------------------- */
/*                              AccountsSection                               */
/* -------------------------------------------------------------------------- */

import 'dart:async';

import 'package:flow_mobile/common/flow_button.dart';
import 'package:flow_mobile/screens/home_screen/components/accounts_card/account_row.dart';
import 'package:flow_mobile/utils/secure_hive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A section listing multiple accounts (e.g., DBS, UOB, etc.).
class AccountsCard extends StatefulWidget {
  final VoidCallback onToggleBalance;

  const AccountsCard({super.key, required this.onToggleBalance});

  @override
  State<AccountsCard> createState() => _AccountsCardState();
}

class _AccountsCardState extends State<AccountsCard> {
  List<dynamic> accountsList = [];
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // Fetch initial accounts data.
    _fetchAccountsData();

    // Poll every 2 seconds for updates.
    _pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchAccountsData();
    });
  }

  void _fetchAccountsData() async {
    // Retrieve the accounts JSON object stored under the 'accounts' key.
    final dynamic accountsData = await SecureHive.getData('accounts');

    // Convert the stored data into a List.
    List<dynamic> newAccountsList;
    if (accountsData is Map) {
      newAccountsList = accountsData.values.toList();
    } else if (accountsData is List) {
      newAccountsList = accountsData;
    } else {
      newAccountsList = [];
    }

    // Compare the new data with the current state.
    if (!listEquals(accountsList, newAccountsList)) {
      setState(() {
        accountsList = newAccountsList;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the polling timer to avoid memory leaks.
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Generate an AccountRow for each account in the list.
          ...accountsList.map((account) {
            final bankName = account['bankName'] ?? 'Unknown Bank';
            final accountType = account['accountType'] ?? 'Unknown Type';

            return AccountRow(
              bankName: bankName,
              accountType: accountType,
              onViewBalance: widget.onToggleBalance,
            );
          }),
          FlowButton(
            onPressed: () {
              // Handle navigation or show more account details.
            },
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'See more about my accounts ',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Color(0xFFA6A6A6), fontSize: 16),
                  ),
                  Image.asset(
                    'assets/icons/vector.png',
                    width: 12,
                    height: 12,
                    color: const Color(0xFFA19F9F),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
