/* -------------------------------------------------------------------------- */
/*                                AccountRow                                  */
/* -------------------------------------------------------------------------- */

import 'package:flutter/widgets.dart';

/// A single row displaying account info and a button to view the balance.
class AccountRow extends StatelessWidget {
  final String bankName;
  final String accountType;
  final VoidCallback onViewBalance;

  const AccountRow({
    super.key,
    required this.bankName,
    required this.accountType,
    required this.onViewBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Icon or placeholder
          Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Image.asset(
              'assets/bank_logos/$bankName.png',
              width: 55,
              height: 55,
            ),
          ),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    accountType,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF565656),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Text(
                  'View Balance',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Button to view or toggle balance
          GestureDetector(
            onTap: onViewBalance,
            child: Container(
              padding: EdgeInsets.all(8),
              width: 65,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/icons/transfer_icon.png',
                width: 65,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
