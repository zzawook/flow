import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsList({super.key, required this.transactions});

  TransactionListState storeToTransactionListStateConverter(
    Store<FlowState> store,
  ) {
    DateTime selectedDate =
        store.state.screenState.spendingScreenState.selectedDate;
    TransactionState transactionState = store.state.transactionState;

    return TransactionListState(
      selectedDate: selectedDate,
      transactionState: transactionState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: StoreConnector<FlowState, TransactionListState>(
        distinct: true,
        converter: (storeToTransactionListStateConverter),
        builder: (context, transactionListState) {
          List<Transaction> transactions = transactionListState.transactionState
              .getTransactionsFromTo(
                transactionListState.selectedDate,
                transactionListState.selectedDate,
              );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                transactions.map((tx) {
                  return TransactionItem(
                    name: tx.name,
                    amount: tx.amount,
                    brandDomain: tx.brandDomain,
                    category: tx.category,
                    color: Color(0xFFEB5757),
                    incomeColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}

class TransactionListState {
  final DateTime selectedDate;
  final TransactionState transactionState;

  TransactionListState({
    required this.selectedDate,
    required this.transactionState,
  });
}
