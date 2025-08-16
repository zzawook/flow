import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingComparetoLastMonthInsight extends ConsumerWidget {
  const SpendingComparetoLastMonthInsight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.onSurface.withAlpha(200);
    final transactionState = ref.watch(transactionStateProvider);
    
    // Calculate monthly spending difference
    final currentMonth = DateTime.now();
    final lastMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    
    final currentMonthSpending = transactionState.transactions
        .where((transaction) {
          return transaction.date.year == currentMonth.year &&
                 transaction.date.month == currentMonth.month &&
                 transaction.amount < 0;
        })
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
    
    final lastMonthSpending = transactionState.transactions
        .where((transaction) {
          return transaction.date.year == lastMonth.year &&
                 transaction.date.month == lastMonth.month &&
                 transaction.amount < 0;
        })
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
    
    final difference = lastMonthSpending - currentMonthSpending;
    
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
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
            'S\$${difference.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' ${difference > 0 ? "less" : "more"} than last month',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}