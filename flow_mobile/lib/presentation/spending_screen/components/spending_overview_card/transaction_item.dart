import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_tag.dart';
import 'package:flutter/material.dart';

/// Individual Transaction Item
class TransactionItem extends StatelessWidget {
  final String name;
  final double amount;
  final String category;
  final Color color;
  final Color incomeColor;

  const TransactionItem({
    super.key,
    required this.name,
    required this.amount,
    required this.category,
    required this.color,
    required this.incomeColor,
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
                        "${amount < 0 ? '-' : '+'}${amount.abs().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: amount > 0 ? incomeColor : color,
                        ),
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          TransactionTag(tag: category, fontSize: 12.0),
        ],
      ),
    );
  }
}
