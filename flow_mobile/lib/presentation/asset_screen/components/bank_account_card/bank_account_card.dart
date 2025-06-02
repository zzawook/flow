import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BankAccountCard extends StatefulWidget {
  const BankAccountCard({super.key});

  @override
  State<BankAccountCard> createState() => _BankAccountCardState();
}

class _BankAccountCardState extends State<BankAccountCard> {
  bool isHiddenAccountsExpanded = false;

  void toggleHiddenAccounts() {
    setState(() {
      isHiddenAccountsExpanded = !isHiddenAccountsExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: StoreConnector<FlowState, List<BankAccount>>(
          converter: (store) {
            return store.state.bankAccountState.bankAccounts;
          },
          builder: (context, bankAccountList) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Accounts",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      FlowSeparatorBox(height: 4),
                      Text(
                        '\$ ${(bankAccountList.fold<double>(0, (sum, account) => sum + account.balance)).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                for (final bankAccount in bankAccountList)
                  if (!bankAccount.isHidden)
                    AccountRow(bankAccount: bankAccount, onViewBalance: () {}),

                FlowSeparatorBox(height: 8),
                FlowButton(
                  onPressed: toggleHiddenAccounts,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isHiddenAccountsExpanded
                              ? "${bankAccountList.where((bankAccount) => bankAccount.isHidden).length} Accounts Hidden from Home Screen"
                              : "Show Hidden Accounts",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isHiddenAccountsExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),

                isHiddenAccountsExpanded
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final bankAccount in bankAccountList)
                          if (!bankAccount.isHidden)
                            AccountRow(
                              bankAccount: bankAccount,
                              onViewBalance: () {
                                Navigator.pushNamed(
                                  context,
                                  '/account_detail',
                                  arguments: CustomPageRouteArguments(
                                    transitionType: TransitionType.slideLeft,
                                    extraData: bankAccount,
                                  ),
                                );
                              },
                            ),
                      ],
                    )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AccountRow extends StatelessWidget {
  final BankAccount bankAccount;
  final VoidCallback onViewBalance;

  const AccountRow({
    super.key,
    required this.bankAccount,
    required this.onViewBalance,
  });

  static const double _spacing = 12;

  void onAccountPressed(BuildContext context) {
    onViewBalance();
    Navigator.pushNamed(
      context,
      '/account_detail',
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideLeft,
        extraData: bankAccount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: _spacing,
        horizontal: _spacing * 2,
      ),
      child: Row(
        children: [
          // Account detail & view-balance button
          Expanded(
            child: FlowButton(
              onPressed: () {
                onAccountPressed(context);
              },
              child: Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 20),
                  _buildLabels(context),
                ],
              ),
            ),
          ),

          const SizedBox(width: _spacing),

          Icon(Icons.menu),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 50,
      height: 50,
      child: Image.asset(
        'assets/bank_logos/${bankAccount.bank.name}.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildLabels(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankAccount.accountName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Color(0xFF565656)
                      : Color(0xFFCCCCCC),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$ ${bankAccount.balance.toString()}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Color(0xFF000000)
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
