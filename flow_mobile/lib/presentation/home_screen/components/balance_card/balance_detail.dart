import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BalanceDetail extends StatelessWidget {
  const BalanceDetail({
    super.key,
    required this.isOnHomeScreen,
  });
  final bool isOnHomeScreen;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, TransactionState>(
      converter: (store) => store.state.transactionState,
      builder:
          (context, transactionState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IncomeContainer(transactionState: transactionState),
              FlowSeparatorBox(height: isOnHomeScreen ? 0 : 16),
              SpendingContainer(
                transactionState: transactionState,
                isOnHomeScreen: isOnHomeScreen,
              ),
              FlowSeparatorBox(height: isOnHomeScreen ? 0 : 16),
              TotalBalanceContainer(transactionState: transactionState),
            ],
          ),
    );
  }
}

class IncomeContainer extends StatelessWidget {
  const IncomeContainer({super.key, required this.transactionState});

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Income',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          Text(
            '+ ${transactionState.getIncomeForMonth(DateTime(DateTime.now().year, DateTime.now().month)).toStringAsFixed(2)} SGD',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingContainer extends StatelessWidget {
  const SpendingContainer({
    super.key,
    required this.transactionState,
    required this.isOnHomeScreen,
  });

  final TransactionState transactionState;
  final bool isOnHomeScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          SpendingTotal(
            transactionState: transactionState,
            isOnHomeScreen: isOnHomeScreen,
          ),
          FlowSeparatorBox(height: isOnHomeScreen ? 0 : 10),
          SpendingDetails(
            transactionState: transactionState,
            isOnHomeScreen: isOnHomeScreen,
          ),
        ],
      ),
    );
  }
}

class TotalBalanceContainer extends StatelessWidget {
  const TotalBalanceContainer({super.key, required this.transactionState});

  final TransactionState transactionState;

  @override
  Widget build(BuildContext context) {
    double totalBalance = transactionState.getBalanceForMonth(
      DateTime(DateTime.now().year, DateTime.now().month),
    );
    return Container(
      padding: EdgeInsets.only(top: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Balance:',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          Text(
            '${totalBalance > 0 ? "+" : "-"} ${totalBalance.toStringAsFixed(2)} SGD',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00C864), // Green color
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingTotal extends StatelessWidget {
  const SpendingTotal({
    super.key,
    required this.transactionState,
    required this.isOnHomeScreen,
  });

  final TransactionState transactionState;
  final bool isOnHomeScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Spending',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          Text(
            '- ${transactionState.getExpenseForMonth(DateTime(DateTime.now().year, DateTime.now().month)).abs().toStringAsFixed(2)} SGD',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingDetails extends StatelessWidget {
  const SpendingDetails({
    super.key,
    required this.transactionState,
    required this.isOnHomeScreen,
  });

  final TransactionState transactionState;
  final bool isOnHomeScreen;

  String processMethod(String method) {
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
    return SizedBox(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 2,
              color: Color(0xFFE5E5E5),
              margin: EdgeInsets.only(right: 12),
            ),
            Expanded(
              child: () {
                List<Transaction> transactions = transactionState.transactions;
                Map<String, List<Transaction>> categorizedTransactions = {};

                for (var transaction in transactions) {
                  if (transaction.amount >= 0) {
                    continue;
                  }
                  String method = processMethod(transaction.method);
                  if (!categorizedTransactions.containsKey(method)) {
                    categorizedTransactions[method] = [];
                  }
                  categorizedTransactions[method]!.add(transaction);
                }
                return Column(
                  children: [
                    CardSpending(
                      transactions:
                          categorizedTransactions['Debit + Credit card'] ?? [],
                    ),
                    FlowSeparatorBox(height: isOnHomeScreen ? 0 : 10),
                    TransferSpending(
                      transactions: categorizedTransactions['Transfer'] ?? [],
                    ),
                    FlowSeparatorBox(height: isOnHomeScreen ? 0 : 10),
                    OtherSpending(
                      transactions: categorizedTransactions['Others'] ?? [],
                    ),
                  ],
                );
              }(),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherSpending extends StatelessWidget {
  const OtherSpending({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    double otherSpending = 0;
    for (var transaction in transactions) {
      otherSpending += transaction.amount;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Others:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            '${otherSpending.abs().toStringAsFixed(2)} SGD',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferSpending extends StatelessWidget {
  const TransferSpending({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    double transferSpending = 0;
    for (var transaction in transactions) {
      if (transaction.date.month != DateTime.now().month ||
          transaction.date.year != DateTime.now().year) {
        continue;
      }
      transferSpending += transaction.amount;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transfer:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            '${transferSpending.abs().toStringAsFixed(2)} SGD',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class CardSpending extends StatelessWidget {
  const CardSpending({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    double cardSpending = 0;
    for (var transaction in transactions) {
      if (transaction.date.month != DateTime.now().month ||
          transaction.date.year != DateTime.now().year) {
        continue;
      }
      cardSpending += transaction.amount;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Debit + Credit card:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            '${cardSpending.abs().toStringAsFixed(2)} SGD',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
