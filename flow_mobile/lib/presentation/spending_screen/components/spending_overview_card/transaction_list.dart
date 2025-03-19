import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flutter/widgets.dart';

/// Transactions List
class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          TransactionItem(
            name: "McDonald's | DBS Debit Card",
            amount: '-\$7.23',
            category: 'Food',
            color: Color(0xAB000000),
          ),
          TransactionItem(
            name: 'PayNow Transfer',
            amount: '+\$17.50',
            category: 'Transfer',
            color: Color(0xFF50C878),
          ),
        ],
      ),
    );
  }
}
