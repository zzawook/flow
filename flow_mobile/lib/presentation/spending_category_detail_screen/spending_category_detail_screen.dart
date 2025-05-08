import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_tag.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SpendingCategoryDetailScreen extends StatelessWidget {
  final String category;
  final DateTime displayMonthYear;

  const SpendingCategoryDetailScreen({
    super.key,
    required this.category,
    required this.displayMonthYear,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFAFAFA),
        child: StoreConnector<FlowState, TransactionState>(
          converter: (store) => store.state.transactionState,
          builder: (context, transactionState) {
            final transactions = transactionState
                .getTransactionByCategoryFromTo(
                  category,
                  DateTime(displayMonthYear.year, displayMonthYear.month, 1),
                  (DateTime(
                        displayMonthYear.year,
                        displayMonthYear.month + 1,
                        0,
                      ).isBefore(DateTime.now()))
                      ? DateTime(
                        displayMonthYear.year,
                        displayMonthYear.month + 1,
                        0,
                      )
                      : DateTime.now(),
                );
            final totalTransactionAmount = transactions.fold(
              0.0,
              (previousValue, element) => previousValue + element.amount,
            );
            return Column(
              children: [
                FlowTopBar(
                  title: Text(
                    "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0x88000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                BalanceSection(
                  category: category,
                  balance: totalTransactionAmount.toStringAsFixed(2),
                  transactionCount: transactions.length,
                ),
                Container(height: 12, color: Color(0xFFF0F0F0)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                    ),
                    child: TransactionList(transactions: transactions),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BalanceSection extends StatelessWidget {
  final String balance;
  final String category;
  final int transactionCount;

  const BalanceSection({
    super.key,
    required this.category,
    required this.balance,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransactionTag(tag: category, fontSize: 16),
          FlowSeparatorBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$ $balance',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          FlowSeparatorBox(height: 32),
          Text(
            '$transactionCount transactions',
            style: TextStyle(fontSize: 14, color: Color(0x88000000)),
          ),
        ],
      ),
    );
  }
}

class SpendingCategoryDetailScreenArguments {
  final String category;
  final DateTime displayMonthYear;

  SpendingCategoryDetailScreenArguments({
    required this.category,
    required this.displayMonthYear,
  });
}
