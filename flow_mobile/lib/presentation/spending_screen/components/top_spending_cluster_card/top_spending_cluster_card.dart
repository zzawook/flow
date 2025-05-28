import 'package:flow_mobile/presentation/spending_screen/components/top_spending_cluster_card/top_spending_cluster.dart';
import 'package:flutter/material.dart';

class TopSpendingClusterCard extends StatelessWidget {
  const TopSpendingClusterCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Top 5 Spendings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TopSpendingCluster()],
          ),
        ],
      ),
    );
  }
}
