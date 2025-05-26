import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/shared/widgets/flow_snackbar.dart';
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
      body: FlowSafeArea(
        backgroundColor: const Color(0xFFFAFAFA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── custom top bar ───────────────────────────────────────────────
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

            // ── balance & copy-to-clipboard section ─────────────────────────
            BalanceSection(bankAccount: bankAccount),

            // thin grey divider
            Container(height: 12, color: const Color(0xFFF0F0F0)),

            // ── transactions list (scrollable) ──────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: StoreConnector<FlowState, TransactionState>(
                  converter: (store) => store.state.transactionState,
                  builder: (_, txnState) {
                    final txns = txnState.getTransactionsByAccount(bankAccount);
                    return TransactionList(transactions: txns);
                  },
                ),
              ),
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
      padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Capture messenger & snackbar synchronously
              final messenger = ScaffoldMessenger.of(context);
              final snack = FlowSnackbar(
                content: const Text(
                  "Copied to clipboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                duration: 2,
              ).build(context);

              // Now do the async, then show using the captured messenger
              Clipboard.setData(
                ClipboardData(
                  text: "${bankAccount.bank.name} ${bankAccount.accountNumber}",
                ),
              ).then((_) {
                messenger.showSnackBar(snack);
              });
            },
            child: Text(
              "${bankAccount.bank.name} ${bankAccount.accountNumber}",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0x88000000),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const FlowSeparatorBox(height: 12),
          Text(
            '\$ ${bankAccount.balance.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
