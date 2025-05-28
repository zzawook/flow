import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingComparetoLastMonthInsight extends StatelessWidget {
  const SpendingComparetoLastMonthInsight({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withAlpha(200);
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 16),
      child: StoreConnector<FlowState, TransactionState>(
        distinct: true,
        converter: (store) => store.state.transactionState,
        builder:
            (context, transactionState) => Row(
              children: [
                Text(
                  'Spending ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: color,
                  ),
                ),
                Text(
                  'S\$${transactionState.getMonthlySpendingDifference().abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' ${transactionState.getMonthlySpendingDifference() > 0 ? "less" : "more"} than last month',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
