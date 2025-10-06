import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/home_screen/components/accounts_card/account_row.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// A card listing the user’s bank accounts, with a “See more” footer.
class AccountsCard extends StatelessWidget {
  final VoidCallback onToggleBalance;

  const AccountsCard({super.key, required this.onToggleBalance});

  List<BankAccount> storeTobankAccountListConverter(Store<FlowState> store) {
    return store.state.bankAccountState.bankAccounts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: StoreConnector<FlowState, List<BankAccount>>(
        converter: (store) => storeTobankAccountListConverter(store),
        builder: (context, accounts) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // One row per account
              for (final account in accounts)
                if (!account.isHidden)
                  AccountRow(
                    bankAccount: account,
                    onViewBalance: onToggleBalance,
                  ),
              // “See more” button
              _SeeMoreButton(),
            ],
          );
        },
      ),
    );
  }
}

class _SeeMoreButton extends StatelessWidget {
  void onSeeMorePressed(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/asset',
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        onSeeMorePressed(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'See more about my accounts',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFFA6A6A6),
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 12, color: Color(0xFFA19F9F)),
          ],
        ),
      ),
    );
  }
}
