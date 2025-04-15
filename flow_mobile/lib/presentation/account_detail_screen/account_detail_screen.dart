import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/spending_detail_screen/transaction_list.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BankAccountDetailScreen extends StatelessWidget {
  final BankAccount bankAccount;

  const BankAccountDetailScreen({super.key, required this.bankAccount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFAFAFA),
        child: Column(
          children: [
            FlowTopBar(
              title: Text(
                'My ${bankAccount.bank.name} ${bankAccount.accountName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0x88000000),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            BalanceSection(bankAccount: bankAccount),
            Container(height: 12, color: Color(0xFFF0F0F0)),
            StoreConnector<FlowState, TransactionState>(
              converter: (store) => store.state.transactionState,
              builder: (context, transactionState) {
                final transactions = transactionState.getTransactionsByAccount(
                  bankAccount,
                );
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                    ),
                    child: TransactionList(transactions: transactions),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceSection extends StatelessWidget {
  final BankAccount bankAccount;

  const BalanceSection({super.key, required this.bankAccount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: "${bankAccount.bank.name} ${bankAccount.accountNumber}",
                ),
              ).then((_) {
                // Provide user feedback by showing a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Copied to clipboard!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 32, left: 24, right: 24),
                    padding: EdgeInsets.only(
                      bottom: 16,
                      top: 16,
                      left: 24,
                      right: 24,
                    ),
                    backgroundColor: Color(0xFF50C864),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              });
            },
            child: Text(
              "${bankAccount.bank.name} ${bankAccount.accountNumber}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0x88000000),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          FlowSeparatorBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$ ${bankAccount.balance.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Transaction List Widget (extracted for clarity; you can leave this as an inline function if preferred)
// class TransactionList extends StatelessWidget {
//   final BankAccount bankAccount;

//   const TransactionList({super.key, required this.bankAccount});

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<FlowState, TransactionState>(
//       converter: (store) => store.state.transactionState,
//       builder: (context, transactionState) {
//         final transactions = transactionState.getTransactionsByAccount(
//           bankAccount,
//         );
//         return Padding(
//           padding: const EdgeInsets.only(left: 24, right: 24, top: 0),
//           child: ListView.builder(
//             itemCount: transactions.length,
//             itemBuilder: (context, index) {
//               final tx = transactions[index];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: TransactionItem(
//                   name: tx.name,
//                   amount: tx.amount,
//                   category: tx.category,
//                   color: Color(0xFF000000),
//                   incomeColor:
//                       tx.amount > 0
//                           ? const Color(0xFF00C864)
//                           : const Color(0xFF000000),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
