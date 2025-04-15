/* -------------------------------------------------------------------------- */
/*                                AccountRow                                  */
/* -------------------------------------------------------------------------- */

import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
/// A single row displaying account info and a button to view the balance.
class AccountRow extends StatelessWidget {
  final BankAccount bankAccount;
  final VoidCallback onViewBalance;

  const AccountRow({
    super.key,
    required this.bankAccount,
    required this.onViewBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Bank logo and text button with constrained width
        Flexible(
          child: FlowButton(
            onPressed: () {
              Navigator.pushNamed(context, "/account_detail",
                  arguments: CustomPageRouteArguments(
                    transitionType: TransitionType.slideLeft,
                    extraData: bankAccount,
                  ));
            },
            child: Container(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 24),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Image.asset(
                      'assets/bank_logos/${bankAccount.bank.name}.png',
                      width: 55,
                      height: 55,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            bankAccount.accountName,
                            style: TextStyle(
                              fontFamily: 'Inter', 
                              fontSize: 15,
                              color: Color(0xFF565656),
                            ),
                          ),
                        ),
                        Text(
                          'View Balance',
                          style: TextStyle(
                            fontFamily: 'Inter', 
                            fontSize: 18,
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Spacing between the two buttons
        SizedBox(width: 8),
        // Transfer icon button with fixed size
        FlowButton(
          onPressed: () {
            StoreProvider.of<FlowState>(
              context,
            ).dispatch(SelectFromBankAccountAction(bankAccount));
            Navigator.pushNamed(
              context,
              '/transfer/to',
              arguments: CustomPageRouteArguments(
                transitionType: TransitionType.slideLeft,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            width: 65,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/icons/transfer_icon.png',
              width: 65,
              height: 40,
            ),
          ),
        ),
        SizedBox(width: 24),
      ],
    );
  }
}
