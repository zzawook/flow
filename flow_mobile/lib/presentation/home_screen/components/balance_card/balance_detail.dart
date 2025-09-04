import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BalanceDetail extends StatelessWidget {
  final bool isOnHomeScreen;

  const BalanceDetail({super.key, required this.isOnHomeScreen});

  TransactionStateAndSpendingScreenState storeToTransactionStateConverter(
    Store<FlowState> store,
  ) {
    return TransactionStateAndSpendingScreenState(
      txState: store.state.transactionState,
      spendingScreenState: store.state.screenState.spendingScreenState,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget separator = FlowSeparatorBox(height: isOnHomeScreen ? 0 : 16);
    return StoreConnector<FlowState, TransactionStateAndSpendingScreenState>(
      converter: (store) => storeToTransactionStateConverter(store),
      builder: (context, states) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IncomeContainer(
              txState: states.txState,
              isOnHomeScreen: isOnHomeScreen,
              spendingScreenState: states.spendingScreenState,
            ),
            separator,
            _SpendingContainer(
              txState: states.txState,
              isOnHomeScreen: isOnHomeScreen,
              spendingScreenState: states.spendingScreenState,
            ),
            separator,
            _TotalBalanceContainer(
              txState: states.txState,
              spendingScreenState: states.spendingScreenState,
              isOnHomeScreen: isOnHomeScreen,
            ),
          ],
        );
      },
    );
  }
}

class TransactionStateAndSpendingScreenState {
  final TransactionState txState;
  final SpendingScreenState spendingScreenState;

  TransactionStateAndSpendingScreenState({
    required this.txState,
    required this.spendingScreenState,
  });
}

class _IncomeContainer extends StatelessWidget {
  final bool isOnHomeScreen;
  final TransactionState txState;
  final SpendingScreenState spendingScreenState;

  const _IncomeContainer({
    required this.txState,
    required this.isOnHomeScreen,
    required this.spendingScreenState,
  });

  @override
  Widget build(BuildContext context) {
    final now = isOnHomeScreen
        ? DateTime.now()
        : spendingScreenState.selectedDate;
    final income = txState
        .getIncomeForMonth(DateTime(now.year, now.month))
        .toStringAsFixed(2);

    final labelStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF555555)
          : Theme.of(context).colorScheme.onSurface.withAlpha(225),
    );

    final valueStyle = labelStyle.copyWith(fontWeight: FontWeight.w900);

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Income', style: labelStyle),
          Text('+ $income SGD', style: valueStyle),
        ],
      ),
    );
  }
}

class _SpendingContainer extends StatelessWidget {
  final TransactionState txState;
  final bool isOnHomeScreen;
  final SpendingScreenState spendingScreenState;

  const _SpendingContainer({
    required this.txState,
    required this.isOnHomeScreen,
    required this.spendingScreenState,
  });

  @override
  Widget build(BuildContext context) {
    final now = isOnHomeScreen
        ? DateTime.now()
        : spendingScreenState.selectedDate;
    final expense = txState
        .getExpenseForMonth(DateTime(now.year, now.month))
        .abs()
        .toStringAsFixed(2);

    final labelStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF555555)
          : Theme.of(context).colorScheme.onSurface.withAlpha(225),
    );

    final valueStyle = labelStyle.copyWith(fontWeight: FontWeight.w900);

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spending', style: labelStyle),
                Text('- $expense SGD', style: valueStyle),
              ],
            ),
          ),
          FlowSeparatorBox(height: isOnHomeScreen ? 0 : 10),
          _SpendingDetails(
            txState: txState,
            isOnHomeScreen: isOnHomeScreen,
            spendingScreenState: spendingScreenState,
          ),
        ],
      ),
    );
  }
}

class _TotalBalanceContainer extends StatelessWidget {
  final bool isOnHomeScreen;
  final SpendingScreenState spendingScreenState;
  final TransactionState txState;

  const _TotalBalanceContainer({
    required this.txState,
    required this.spendingScreenState,
    required this.isOnHomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    final now = isOnHomeScreen
        ? DateTime.now()
        : spendingScreenState.selectedDate;
    final balance = txState.getBalanceForMonth(DateTime(now.year, now.month));
    final sign = balance >= 0 ? '+' : '-';

    final totalBalanceStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor);

    return Container(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Balance:', style: totalBalanceStyle),
          Text(
            '$sign ${balance.abs().toStringAsFixed(2)} SGD',
            style: totalBalanceStyle,
          ),
        ],
      ),
    );
  }
}

class _SpendingDetails extends StatelessWidget {
  final TransactionState txState;
  final bool isOnHomeScreen;
  final SpendingScreenState spendingScreenState;

  const _SpendingDetails({
    required this.txState,
    required this.isOnHomeScreen,
    required this.spendingScreenState,
  });

  String _processMethod(String method) {
    if (method == 'Credit Card' || method == 'Debit Card') {
      return 'Debit + Credit card';
    } else if (method == 'Transfer' || method == 'PayNow') {
      return 'Transfer';
    } else {
      return 'Others';
    }
  }

  bool _isTargetMonth(DateTime date) {
    final now = isOnHomeScreen
        ? DateTime.now()
        : spendingScreenState.selectedDate;
    return date.year == now.year && date.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    // Categorize all negative‐amount transactions
    final categorized = <String, List<Transaction>>{};
    for (var t in txState.transactions) {
      if (t.amount >= 0 || !_isTargetMonth(t.date)) continue;
      final key = _processMethod(t.method);
      categorized.putIfAbsent(key, () => []).add(t);
    }

    return SizedBox(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 2,
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(0xFFE5E5E5)
                  : Color(0xFF444444),
              margin: const EdgeInsets.only(right: 12),
            ),
            Expanded(
              child: Column(
                children: [
                  CardSpending(
                    transactions: categorized['Debit + Credit card'] ?? [],
                  ),
                  FlowSeparatorBox(height: isOnHomeScreen ? 0 : 10),
                  TransferSpending(transactions: categorized['Transfer'] ?? []),
                  FlowSeparatorBox(height: isOnHomeScreen ? 0 : 10),
                  OtherSpending(transactions: categorized['Others'] ?? []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardSpending extends StatelessWidget {
  final List<Transaction> transactions;

  const CardSpending({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double total = 0;
    final now = DateTime.now();

    for (var t in transactions) {
      if (t.date.year != now.year || t.date.month != now.month) continue;
      total += t.amount;
    }

    final detailValueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF666666)
          : const Color(0xFFAFAFAF),
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Debit + Credit card:', style: detailValueStyle),
          Text(
            '${total.abs().toStringAsFixed(2)} SGD',
            style: detailValueStyle,
          ),
        ],
      ),
    );
  }
}

class TransferSpending extends StatelessWidget {
  final List<Transaction> transactions;

  const TransferSpending({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double total = 0;
    final now = DateTime.now();

    for (var t in transactions) {
      if (t.date.year != now.year || t.date.month != now.month) continue;
      total += t.amount;
    }

    final detailValueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF666666)
          : const Color(0xFFAFAFAF),
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Transfer:', style: detailValueStyle),
          Text(
            '${total.abs().toStringAsFixed(2)} SGD',
            style: detailValueStyle,
          ),
        ],
      ),
    );
  }
}

class OtherSpending extends StatelessWidget {
  final List<Transaction> transactions;

  const OtherSpending({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var t in transactions) {
      total += t.amount;
    }

    final detailValueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF666666)
          : const Color(0xFFAFAFAF),
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Others:', style: detailValueStyle),
          Text(
            '${total.abs().toStringAsFixed(2)} SGD',
            style: detailValueStyle,
          ),
        ],
      ),
    );
  }
}
