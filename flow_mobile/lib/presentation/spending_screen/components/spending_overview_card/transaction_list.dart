import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsList extends ConsumerWidget {
  final List<Transaction> transactions;

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final selectedDate = ref.watch(spendingScreenStateProvider).selectedDate;
          final transactionState = ref.watch(transactionStateProvider);
          
          // Filter transactions for the selected date
          List<Transaction> filteredTransactions = transactionState.transactions
              .where((transaction) {
                return transaction.date.year == selectedDate.year &&
                       transaction.date.month == selectedDate.month &&
                       transaction.date.day == selectedDate.day;
              })
              .toList();
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filteredTransactions.map((tx) {
              return TransactionItem(
                name: tx.name,
                amount: tx.amount,
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


