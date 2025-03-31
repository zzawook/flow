/* -------------------------------------------------------------------------- */
/*                              BalanceSection                                */
/* -------------------------------------------------------------------------- */

import 'dart:async';

import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_data.dart';
import 'package:flow_mobile/presentation/home_screen/components/balance_card/balance_detail.dart';
import 'package:flow_mobile/data/source/local_secure_hive.dart';
import 'package:flutter/widgets.dart';

/// Displays the current month's balance, income, spending, and more.
class BalanceCard extends StatefulWidget {
  final bool showBalance;

  const BalanceCard({super.key, required this.showBalance});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  BalanceData balanceData = BalanceData(0, 0, 0, 0);
  double totalSpending = 0;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();

    _fetchBalanceData();

    _pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchBalanceData();
    });
  }

  void _fetchBalanceData() async {
    final dynamic fetchedBalanceData = await SecureHive.getData(
      'monthlyBalance',
    );

    BalanceData newBalanceData;
    if (fetchedBalanceData is Map) {
      newBalanceData = BalanceData.fromDynamicJson(fetchedBalanceData);
    } else {
      throw Exception("Balance Data is Missing");
    }

    setState(() {
      balanceData = newBalanceData;
    });
  }

  @override
  void dispose() {
    // Cancel the polling timer to avoid memory leaks.
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        Navigator.pushNamed(context, '/spending');
      },
      child: Container(
        padding: EdgeInsets.only(top: 24, left: 24, right: 24),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceCardTitle(),
            AsOfDateText(),

            // Income & Spending
            BalanceDetail(balanceData: balanceData),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 20,
                  right: 8,
                  left: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Find out more ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFFA6A6A6),
                        fontSize: 18,
                      ),
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
      ),
    );
  }
}



class AsOfDateText extends StatelessWidget {
  const AsOfDateText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25),
      child: Text(
        'As of 15 January',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: Color(0xFF000000),
        ),
      ),
    );
  }
}

class BalanceCardTitle extends StatelessWidget {
  const BalanceCardTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(
        "This month's Balance",
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontFamily: 'Inter', 
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
      ),
    );
  }
}
