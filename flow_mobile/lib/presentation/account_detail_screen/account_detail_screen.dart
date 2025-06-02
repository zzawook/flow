import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
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
        backgroundColor: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── custom top bar ───────────────────────────────────────────────
            FlowTopBar(
              title: StoreConnector<FlowState, String>(
                converter: (store) {
                  BankAccountState bankAccountState =
                      store.state.bankAccountState;
                  for (var bankAccount in bankAccountState.bankAccounts) {
                    if (bankAccount.isEqualTo(this.bankAccount)) {
                      return bankAccount.accountName;
                    }
                  }
                  return bankAccount.accountName;
                },
                builder: (_, accountName) {
                  return Text(
                    accountName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              leftWidget: FlowButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/bank_account/setting",
                    arguments: CustomPageRouteArguments(
                      transitionType: TransitionType.slideRight,
                      extraData: bankAccount,
                    ),
                  );
                },
                child: SizedBox(
                  width: 25,
                  child: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // ── balance & copy-to-clipboard section ─────────────────────────
            BalanceSection(bankAccount: bankAccount),

            // thin grey divider
            Container(
              height: 12,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).canvasColor
                      : const Color(0xFF303030),
            ),

            // ── transactions list (scrollable) ──────────────────────────────
            Expanded(
              child: StoreConnector<FlowState, TransactionState>(
                converter: (store) => store.state.transactionState,
                builder: (_, txnState) {
                  final txns = txnState.getTransactionsByAccount(bankAccount);
                  return TransactionList(transactions: txns);
                },
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const FlowSeparatorBox(height: 12),
          Text(
            '\$ ${bankAccount.balance.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
