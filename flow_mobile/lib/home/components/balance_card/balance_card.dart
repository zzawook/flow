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
          Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "This month's Balance",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 25),
            child: Text(
              'As of 15 January',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 13, color: Color(0xFF000000)),
            ),
          ),

          // Income & Spending
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Income',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF555555),
                      ),
                    ),
                    Text(
                      'S\$4,300.00',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Spending',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF555555),
                            ),
                          ),
                          Text(
                            'S\$3,734.35',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 2,
                              color: Color(0xFFE5E5E5),
                              margin: EdgeInsets.only(right: 12),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Debit + Credit card:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                        Text(
                                          'S\$732.12',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Transfer:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                        Text(
                                          'S\$2,000.00',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Others:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                        Text(
                                          'S\$1,002.23',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: EdgeInsets.only(top: 7),
                child: Row(
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
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle "Find out more"
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Find out more ',
                    style: TextStyle(color: Color(0xFFA6A6A6), fontSize: 18),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    child: Image.asset(
                      'assets/icons/vector.png',
                      width: 12,
                      height: 12,
                      color: Color(0xFFA19F9F),
                    ),
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
