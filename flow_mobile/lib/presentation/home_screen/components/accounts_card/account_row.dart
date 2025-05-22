import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


/// A single row displaying account info, a “View Balance” action, and a quick-transfer button.
class AccountRow extends StatelessWidget {
  final BankAccount bankAccount;
  final VoidCallback onViewBalance;

  const AccountRow({
    super.key,
    required this.bankAccount,
    required this.onViewBalance,
  });

  static const double _avatarSize = 55;
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

  void onQuickTransferPressed(BuildContext context) {
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
                  _buildLabels(),
                ],
              ),
            ),
          ),

          const SizedBox(width: _spacing),

          // Quick-transfer button
          FlowButton(
            onPressed: () {
              onQuickTransferPressed(context);
            },
            child: Container(
              width: 65,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.swap_horiz,
                size: 24,
                color: Color(0xFF565656),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(_avatarSize / 2),
      ),
      child: Image.asset(
        'assets/bank_logos/${bankAccount.bank.name}.png',
        width: _avatarSize,
        height: _avatarSize,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildLabels() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankAccount.accountName,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: Color(0xFF565656),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'View Balance',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
