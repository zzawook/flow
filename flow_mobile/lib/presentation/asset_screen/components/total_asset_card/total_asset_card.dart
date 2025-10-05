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
        isLoading: store.state.screenState.assetScreenState.isLoading,
        error: store.state.screenState.assetScreenState.error,
      ),
      builder: (context, vm) => _TotalAssetCardContent(
        monthlyAssets: vm.monthlyAssets,
        isLoading: vm.isLoading,
        error: vm.error,
      ),
    );
  }
}

class _ViewModel {
  final Map<DateTime, double> monthlyAssets;
  final bool isLoading;
  final String? error;

  _ViewModel({
    required this.monthlyAssets,
    required this.isLoading,
    this.error,
  });
}

class _TotalAssetCardContent extends StatelessWidget {
  final Map<DateTime, double> monthlyAssets;
  final bool isLoading;
  final String? error;

  const _TotalAssetCardContent({
    required this.monthlyAssets,
    required this.isLoading,
    this.error,
  });

  Widget _getCurrentMonthStatusComparedToLastMonthMessage(
    BuildContext context,
  ) {
    if (monthlyAssets.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get most recent month (current) and previous month
    final sortedDates = monthlyAssets.keys.toList()..sort();
    if (sortedDates.length < 2) {
      return const SizedBox.shrink();
    }

    final currentMonth = sortedDates.last;
    final lastMonth = sortedDates[sortedDates.length - 2];
    final currentMonthAmount = monthlyAssets[currentMonth] ?? 0.0;
    final lastMonthAmount = monthlyAssets[lastMonth] ?? 0.0;

    Widget message = Row(
      children: [
        Text(
          "\$ ${(currentMonthAmount - lastMonthAmount).abs().toStringAsFixed(2)} ${currentMonthAmount > lastMonthAmount ? "more" : "less"}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: currentMonthAmount < lastMonthAmount
                ? Colors.red
                : Theme.of(context).primaryColor,
          ),
        ),
        Text(
          " than last month",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );

    return message;
  }

  @override
  Widget build(BuildContext context) {
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
                _getCurrentMonthStatusComparedToLastMonthMessage(context),
              ],
            ),
          ),
          // Chart area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            height: 300,
            child: _buildChartContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    // Show loading state
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
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

    // Show empty state
    if (monthlyAssets.isEmpty) {
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

    // Show chart with data
    return MonthlyAssetBarChart(
      last6MonthlyAssetData: monthlyAssets,
      normalBarColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFCACACA)
          : const Color(0xFF4A4A4A),
    );
  }
}
