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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top 5 Spending',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
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
