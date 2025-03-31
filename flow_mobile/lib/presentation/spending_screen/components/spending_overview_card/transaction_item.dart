import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_tag.dart';
import 'package:flutter/widgets.dart';

/// Individual Transaction Item
class TransactionItem extends StatelessWidget {
  final String name;
  final String amount;
  final String category;
  final Color color;

  const TransactionItem({
    super.key,
    required this.name,
    required this.amount,
    required this.category,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    'assets/icons/transaction_icons/mcdonalds.png',
                    height: 50,
                    width: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        amount,
                        style: TextStyle(
                          fontFamily: 'Inter', 
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter', 
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF565656),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          TransactionTag(tag: category),
        ],
      ),
    );
  }
}
