import 'dart:math';

import 'package:flow_mobile/domain/redux/actions/bank_account_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';

class BankAccountCard extends StatefulWidget {
  const BankAccountCard({super.key});

  @override
  State<BankAccountCard> createState() => _BankAccountCardState();
}

class _BankAccountCardState extends State<BankAccountCard> {
  bool isHiddenAccountsExpanded = false;

  void _toggleHidden() =>
      setState(() => isHiddenAccountsExpanded = !isHiddenAccountsExpanded);

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: StoreConnector<FlowState, _VM>(
          converter: (store) {
            final accounts = store.state.bankAccountState.bankAccounts;
            return _VM(accounts, (oldI, newI, toggIdx) {
              if (oldI == newI) return;

              // ─── handle re-order in Redux ───────────────────────────────
              final list = [...accounts];

              bool isHiddenToggled =
                  (oldI < toggIdx && newI >= toggIdx) ||
                  (oldI > toggIdx && newI <= toggIdx);

              oldI = oldI > toggIdx ? oldI - 1 : oldI;
              newI = newI > toggIdx ? newI - 1 : min(newI, accounts.length - 1);

              final moved = list.removeAt(oldI);
              StoreProvider.of<FlowState>(context).dispatch(
                UpdateAccountOrderAction(
                  bankAccount: moved,
                  newIndex: newI,
                  oldIndex: oldI,
                ),
              );

              // flip hidden flag if we crossed the toggle row
              if (isHiddenToggled) {
                StoreProvider.of<FlowState>(
                  context,
                ).dispatch(ToggleBankAccountHiddenAction(bankAccount: moved));
              }
            });
          },
          builder: (ctx, vm) {
            final visible = vm.accounts.where((a) => !a.isHidden).toList();
            final hidden = vm.accounts.where((a) => a.isHidden).toList();
            final toggleIdx = visible.length; // fixed row index

            // —— build an item list: visible • TOGGLE • maybe hidden ———
            final itemCount =
                visible.length +
                1 +
                (isHiddenAccountsExpanded ? hidden.length : 0);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Accounts",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '\$ ${(vm.accounts.fold<double>(0, (sum, account) => sum + account.balance)).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ReorderableListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: itemCount,
                  onReorder: (oldIdx, newIdx) {
                    if (newIdx > oldIdx) newIdx--; // framework quirk

                    // prevent dragging the toggle row itself
                    if (oldIdx == toggleIdx) return;

                    vm.onReorder(oldIdx, newIdx, toggleIdx);
                  },
                  itemBuilder: (ctx, idx) {
                    if (idx == toggleIdx) {
                      // ─── the fixed "Show Hidden" row ────────────────────────
                      return _ToggleRow(
                        key: const ValueKey('toggle-row'),
                        expanded: isHiddenAccountsExpanded,
                        hiddenCount: hidden.length,
                        onTap: _toggleHidden,
                      );
                    }

                    // map index → BankAccount
                    BankAccount acct;
                    if (idx < toggleIdx) {
                      acct = visible[idx];
                    } else {
                      final hiddenIdx = idx - toggleIdx - 1;
                      acct = hidden[hiddenIdx];
                    }

                    return _AccountRow(
                      key: ValueKey(acct.accountNumber),
                      bankAccount: acct,
                      listIndex: idx,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/*────────────────────────── VM helper ──────────────────────────*/
class _VM {
  final List<BankAccount> accounts;
  final void Function(int oldI, int newI, int toggleIdx) onReorder;
  _VM(this.accounts, this.onReorder);
}

/*────────────────────────── ROW widgets ─────────────────────────*/

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    super.key,
    required this.bankAccount,
    required this.listIndex,
  });

  final BankAccount bankAccount;
  final int listIndex;

  static const _spacing = 12.0;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      key: key, // ReorderableListView needs this
      padding: const EdgeInsets.symmetric(
        vertical: _spacing,
        horizontal: _spacing * 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: FlowButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/account_detail',
                  arguments: bankAccount, // simplified
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/bank_logos/${bankAccount.bank.name}.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankAccount.accountName,
                          style: TextStyle(color: onSurface.withAlpha(180)),
                        ),
                        Text(
                          '\$ ${bankAccount.balance}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: _spacing),

          // ── drag handle
          ReorderableDragStartListener(
            index: listIndex,
            child: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    super.key,
    required this.expanded,
    required this.hiddenCount,
    required this.onTap,
  });

  final bool expanded;
  final int hiddenCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        expanded
            ? '$hiddenCount Accounts Hidden from Home Screen'
            : 'Show Hidden Accounts';

    return FlowButton(
      key: key,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15, color: Color(0xFFA6A6A6)),
            ),
            const SizedBox(width: 8),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
