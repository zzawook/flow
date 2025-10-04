import 'package:flow_mobile/domain/entity/recurring_spending.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/spending_screen_thunks.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_screen/components/fixed_spending_card/recurring_spending_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class FixedSpendingCard extends StatelessWidget {
  /// The month to show initially
  final DateTime initialMonth;

  const FixedSpendingCard({super.key, required this.initialMonth});

  String _formatSGDollarSign(double amount) {
    final f = NumberFormat.currency(
      locale: 'en_SG',
      symbol: '\$ ',
      decimalDigits: 2,
    );
    return f.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, _FixedSpendingViewModel>(
      distinct: true,
      converter: (store) {
        final displayedMonth =
            store.state.screenState.spendingScreenState.displayedMonth;
        final recurring = store.state.screenState.spendingScreenState
            .getRecurringForMonth(displayedMonth);
        final totalAmount = store.state.screenState.spendingScreenState
            .getTotalRecurringForMonth(displayedMonth);
        final isLoading =
            store.state.screenState.spendingScreenState.isLoadingRecurring;
        final error =
            store.state.screenState.spendingScreenState.recurringError;

        return _FixedSpendingViewModel(
          displayedMonth: displayedMonth,
          recurring: recurring,
          totalAmount: totalAmount,
          isLoading: isLoading,
          error: error,
        );
      },
      onInit: (store) {
        // Fetch recurring spending data on mount
        store.dispatch(fetchRecurringSpendingThunk());
      },
      onDidChange: (previousViewModel, newViewModel) {
        // Refetch when month changes (data is already grouped by month)
        if (previousViewModel?.displayedMonth != newViewModel.displayedMonth) {
          // Data is already grouped by month, no need to refetch
        }
      },
      builder: (context, viewModel) {
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header always visible
                      _buildHeader(context, viewModel),

                      const SizedBox(height: 16),

                      // Conditional content based on state
                      Row(
                        children: [
                          Expanded(
                            child: (viewModel.isLoading)
                                ? _buildLoadingContent()
                                : (viewModel.error != null)
                                ? _buildErrorContent(context, viewModel.error!)
                                : (viewModel.recurring.isEmpty)
                                ? _buildEmptyContent(context)
                                : Column(
                                    children: _buildRecurringItems(
                                      context,
                                      viewModel,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, _FixedSpendingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recurring Spendings",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          (!viewModel.isLoading &&
                  viewModel.error == null &&
                  viewModel.recurring.isNotEmpty)
              ? Text(
                  _formatSGDollarSign(viewModel.totalAmount),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C864),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            "Unable to load recurring spendings",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.repeat, color: Colors.grey, size: 48),
          SizedBox(height: 16),
          Text(
            "No recurring spendings found yet",
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            "We are continuously analyzing your transactions",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecurringItems(
    BuildContext context,
    _FixedSpendingViewModel viewModel,
  ) {
    return viewModel.recurring.map((recurring) {
      return RecurringSpendingItem(
        recurring: recurring,
        month: viewModel.displayedMonth,
        onTap: () {
          Navigator.pushNamed(
            context,
            "/fixed_spending/details",
            arguments: CustomPageRouteArguments(
              transitionType: TransitionType.slideLeft,
              extraData: viewModel.displayedMonth,
            ),
          );
        },
      );
    }).toList();
  }
}

class _FixedSpendingViewModel {
  final DateTime displayedMonth;
  final List<RecurringSpending> recurring;
  final double totalAmount;
  final bool isLoading;
  final String? error;

  _FixedSpendingViewModel({
    required this.displayedMonth,
    required this.recurring,
    required this.totalAmount,
    required this.isLoading,
    this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _FixedSpendingViewModel &&
        other.displayedMonth == displayedMonth &&
        _listEquals(other.recurring, recurring) &&
        other.totalAmount == totalAmount &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return displayedMonth.hashCode ^
        recurring.hashCode ^
        totalAmount.hashCode ^
        isLoading.hashCode ^
        (error?.hashCode ?? 0);
  }

  bool _listEquals(List<RecurringSpending> a, List<RecurringSpending> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
