import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/shared/widgets/flow_horizontal_divider.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/widgets.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final sortedTransaction =
        transactions..sort((a, b) => b.date.compareTo(a.date));
    if (sortedTransaction.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF000000),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      // shrinkWrap: true,
      itemCount: sortedTransaction.length,
      itemBuilder: (context, index) {
        final transaction = sortedTransaction[index];
        final dateLabel = DateTimeUtil.getFormattedDate(transaction.date);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Label
            if (index == 0 ||
                !DateTimeUtil.isSameDate(
                  sortedTransaction[index - 1].date,
                  transaction.date,
                ))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 0 : 24,
                      bottom: 8,
                    ),
                    child: Text(
                      dateLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  FlowHorizontalDivider(),
                  FlowSeparatorBox(height: 8),
                ],
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TransactionItem(
                name: transaction.name,
                amount: transaction.amount,
                category: transaction.category,
                color: Color(0xFF000000),
                incomeColor:
                    transaction.amount > 0
                        ? const Color(0xFF00C864)
                        : const Color(0xFF000000),
              ),
            ),
          ],
        );
      },
    );
  }
}
