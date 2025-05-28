import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BalanceDetail extends StatelessWidget {
  final bool isOnHomeScreen;

  const BalanceDetail({super.key, required this.isOnHomeScreen});

  TransactionState storeToTransactionStateConverter(Store<FlowState> store) {
    return store.state.transactionState;
  }

  @override
  Widget build(BuildContext context) {
    Widget separator = FlowSeparatorBox(height: isOnHomeScreen ? 0 : 16);
    return StoreConnector<FlowState, TransactionState>(
      converter: (store) => storeToTransactionStateConverter(store),
      builder: (context, txState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IncomeContainer(txState: txState),
            separator,
            _SpendingContainer(
              txState: txState,
              isOnHomeScreen: isOnHomeScreen,
            ),
            separator,
            _TotalBalanceContainer(txState: txState),
          ],
        );
      },
    );
  }
}

class _IncomeContainer extends StatelessWidget {
  final TransactionState txState;

  const _IncomeContainer({required this.txState});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final income = txState
        .getIncomeForMonth(DateTime(now.year, now.month))
        .toStringAsFixed(2);

    final labelStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color:
          Theme.of(context).brightness == Brightness.light
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

  const _SpendingContainer({
    required this.txState,
    required this.isOnHomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final expense = txState
        .getExpenseForMonth(DateTime(now.year, now.month))
        .abs()
        .toStringAsFixed(2);

    final labelStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color:
          Theme.of(context).brightness == Brightness.light
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
          _SpendingDetails(txState: txState, isOnHomeScreen: isOnHomeScreen),
        ],
      ),
    );
  }
}

class _TotalBalanceContainer extends StatelessWidget {
  final TransactionState txState;

  const _TotalBalanceContainer({required this.txState});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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

  const _SpendingDetails({required this.txState, required this.isOnHomeScreen});

  String _processMethod(String method) {
    if (method == 'Credit Card' || method == 'Debit Card') {
      return 'Debit + Credit card';
    } else if (method == 'Transfer' || method == 'PayNow') {
      return 'Transfer';
    } else {
      return 'Others';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Categorize all negative‐amount transactions
    final categorized = <String, List<Transaction>>{};
    for (var t in txState.transactions) {
      if (t.amount >= 0) continue;
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
              color:
                  Theme.of(context).brightness == Brightness.light
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
      color:
          Theme.of(context).brightness == Brightness.light
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
      color:
          Theme.of(context).brightness == Brightness.light
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
      color:
          Theme.of(context).brightness == Brightness.light
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
