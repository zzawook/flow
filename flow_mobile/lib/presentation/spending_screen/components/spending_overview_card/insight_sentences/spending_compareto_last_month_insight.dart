import 'package:flutter/widgets.dart';

class SpendingComparetoLastMonthInsight extends StatelessWidget {
  const SpendingComparetoLastMonthInsight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        children: [
          Text(
            'Spending ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0x88000000),
            ),
          ),
          Text(
            'S\$469.68',
            style: TextStyle(
              fontFamily: 'Inter', 
              fontSize: 14,
              color: Color(0xFF50C878),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' less than last month',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0x88000000),
            ),
          ),
        ],
      ),
    );
  }
}
