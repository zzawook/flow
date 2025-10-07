import 'dart:collection';

import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/asset_screen/components/total_asset_card/monthly_asset_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TotalAssetCard extends StatelessWidget {
  const TotalAssetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, _ViewModel>(
      converter: (store) => _ViewModel(
        monthlyAssets: store.state.screenState.assetScreenState.monthlyAssets,
        bankAccounts: store.state.bankAccountState.bankAccounts,
        cards: store.state.cardState.cards,
        isLoading: store.state.screenState.assetScreenState.isLoading,
        error: store.state.screenState.assetScreenState.error,
      ),
      builder: (context, vm) => _TotalAssetCardContent(
        monthlyAssets: vm.monthlyAssets,
        bankAccounts: vm.bankAccounts,
        cards: vm.cards,
        isLoading: vm.isLoading,
        error: vm.error,
      ),
    );
  }
}

class _ViewModel {
  final Map<DateTime, double> monthlyAssets;
  final List<BankAccount> bankAccounts;
  final List<BankCard.Card> cards;
  final bool isLoading;
  final String? error;

  _ViewModel({
    required this.monthlyAssets,
    required this.bankAccounts,
    required this.cards,
    required this.isLoading,
    this.error,
  });
}

class _TotalAssetCardContent extends StatelessWidget {
  final Map<DateTime, double> monthlyAssets;
  final List<BankAccount> bankAccounts;
  final List<BankCard.Card> cards;
  final bool isLoading;
  final String? error;

  const _TotalAssetCardContent({
    required this.monthlyAssets,
    required this.bankAccounts,
    required this.cards,
    required this.isLoading,
    this.error,
  });

  /// Build a mutable, sorted view-only map for the last 6 months.
  Map<DateTime, double> _buildDisplayMonthlyAssets() {
    if (bankAccounts.isEmpty && cards.isEmpty) {
      return {};
    }

    final data = HashMap<DateTime, double>();
    data.addAll(monthlyAssets); // safe copy; still empty if store is empty

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    if (data.isEmpty) {
      // Fill previous 5 months with 0.0
      for (int i = 1; i <= 5; i++) {
        data[DateTime(monthStart.year, monthStart.month - i, 1)] = 0.0;
      }
    }

    final currentMonthAccountSum = bankAccounts.fold<double>(
      0,
      (s, a) => s + a.balance,
    );
    final currentMonthCardSum = cards.fold<double>(0, (s, c) => s + c.balance);

    // Use whatever net rule you intend; keeping your original minus:
    data[monthStart] = currentMonthAccountSum + currentMonthCardSum;

    // Keep only the latest 6 months if you want to cap it
    if (data.length > 6) {
      final keys = data.keys.toList();
      for (int i = 0; i < keys.length - 6; i++) {
        data.remove(keys[i]);
      }
    }
    return data;
  }

  Widget _getCurrentMonthStatusComparedToLastMonthMessage(
    BuildContext context,
  ) {
    final data = _buildDisplayMonthlyAssets();

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final dates = data.keys.toList()..sort();
    final currentMonth = dates.last;
    final lastMonth = dates.length >= 2 ? dates[dates.length - 2] : null;

    final currentMonthAmount = data[currentMonth] ?? 0.0;
    final lastMonthAmount = lastMonth != null ? data[lastMonth] ?? 0.0 : 0.0;

    final diff = (currentMonthAmount - lastMonthAmount);
    final moreOrLess = diff >= 0 ? "more" : "less";
    final highlightColor = diff < 0
        ? Colors.red
        : Theme.of(context).primaryColor;

    return Row(
      children: [
        Text(
          "\$ ${diff.abs().toStringAsFixed(2)} $moreOrLess",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: highlightColor,
          ),
        ),
        Text(
          " than last month",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataForView = _buildDisplayMonthlyAssets();

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and comparison message
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '\$ ${dataForView.isNotEmpty ? dataForView[DateTime(DateTime.now().year, DateTime.now().month)]?.toStringAsFixed(2) : "0.00"}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _getCurrentMonthStatusComparedToLastMonthMessage(context),
              ],
            ),
          ),
          // Chart area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            height: 300,
            child: _buildChartContent(context, dataForView),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent(BuildContext context, Map<DateTime, double> data) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
            const SizedBox(height: 16),
            Text(
              error!,
              style: TextStyle(color: Colors.red.shade300, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              color: Colors.grey.shade400,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No asset data available',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return MonthlyAssetBarChart(
      last6MonthlyAssetData: data, // pass the derived, mutable view
      normalBarColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFCACACA)
          : const Color(0xFF4A4A4A),
    );
  }
}
