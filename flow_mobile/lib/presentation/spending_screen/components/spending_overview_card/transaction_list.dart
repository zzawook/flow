import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: StoreConnector<FlowState, DateTime>(
        distinct: true,
        converter:
            (store) => store.state.screenState.spendingScreenState.selectedDate,
        builder: (context, selectedDate) {
          List<Transaction> transactions =
              this.transactions
                  .where(
                    (transaction) =>
                        DateTimeUtil.isSameDate(transaction.date, selectedDate),
                  )
                  .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                transactions.map((tx) {
                  return TransactionItem(
                    name: tx.name,
                    amount: tx.amount,
                    category: tx.category,
                    color: Color(0xFFEB5757),
                    incomeColor: Color(0xFF50C878),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
