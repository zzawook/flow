/* -------------------------------------------------------------------------- */
/*                              AccountsSection                               */
/* -------------------------------------------------------------------------- */

import 'package:flow_mobile/home/components/accounts_card/account_row.dart';
import 'package:flutter/widgets.dart';

/// A section listing multiple accounts (e.g., DBS, UOB, etc.).
class AccountsCard extends StatelessWidget {
  final VoidCallback onToggleBalance;

  const AccountsCard({super.key, required this.onToggleBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Example account rows
          AccountRow(
            bankName: 'DBS',
            accountType: 'Savings account',
            onViewBalance: onToggleBalance,
          ),
          AccountRow(
            bankName: 'UOB',
            accountType: 'Savings account',
            onViewBalance: onToggleBalance,
          ),
          AccountRow(
            bankName: 'Maybank',
            accountType: 'Savings account',
            onViewBalance: onToggleBalance,
          ),

          GestureDetector(
            onTap: () {
              // Navigate or show more details
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See more about my accounts ',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Color(0xFFA6A6A6),
                      fontSize: 16,
                    ),
                  ),
                  Image.asset(
                    'assets/icons/vector.png',
                    width: 12,
                    height: 12,
                    color: Color(0xFFA19F9F),
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
