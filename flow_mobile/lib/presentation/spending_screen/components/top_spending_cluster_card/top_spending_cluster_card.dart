import 'dart:collection';

import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/spending_screen/components/top_spending_cluster_card/top_spending_cluster.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TopSpendingClusterCard extends StatelessWidget {
  const TopSpendingClusterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, List<Transaction>>(
      converter: (store) => store.state.transactionState.transactions
          .where(
            (t) =>
                t.amount < 0 &&
                DateTimeUtil.isSameMonth(
                  t.date,
                  store.state.screenState.spendingScreenState.displayedMonth,
                ) &&
                t.isIncludedInSpendingOrIncome &&
                t.brandName.isNotEmpty,
          )
          .toList(),
      builder: (context, transactions) {
        if (transactions.isEmpty) {
          return SizedBox.shrink();
        }
        final HashMap<String, List<Transaction>> spendingByBrand = HashMap();
        for (var transaction in transactions) {
          spendingByBrand.putIfAbsent(transaction.brandName, () => []);
          spendingByBrand[transaction.brandName]!.add(transaction);
        }
        return Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top 5 transaction count',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopSpendingCluster(spendingByBrand: spendingByBrand),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
