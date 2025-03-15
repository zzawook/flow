/* -------------------------------------------------------------------------- */
/*                              BalanceSection                                */
/* -------------------------------------------------------------------------- */

import 'package:flutter/widgets.dart';

/// Displays the current month's balance, income, spending, and more.
class BalanceCard extends StatelessWidget {
  final bool showBalance;

  const BalanceCard({super.key, required this.showBalance});

  @override
  Widget build(BuildContext context) {
    // For example, hide or show the final amount based on `showBalance`
    final displayedBalance = showBalance ? 'S\$565.65' : '*****';

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This month's Balance",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'As of 15 January',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 13, color: Color(0xFF000000)),
          ),
          SizedBox(height: 16),

          // Income & Spending
          Row(
            children: [
              Container(
                width: 2, // Line thickness,
                height: 100,
                color: Color(0xFFC8C8C8), // Line color
                margin: EdgeInsets.only(right: 15),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Income',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555),
                        ),
                      ),
                      Text(
                        'S\$4,300.00',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spending',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555),
                        ),
                      ),
                      Text(
                        'S\$3,734.35',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Debit + Credit card: S\$732.12\n'
                    'Transfer: S\$2,000.00\n'
                    'Others: S\$1,002.23',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance:',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF555555),
                        ),
                      ),
                      Text(
                        displayedBalance,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C864), // Green color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle "Find out more"
            },
            child: Text(
              'Find out more >',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Color(0xFF555555),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
