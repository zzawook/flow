import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single row displaying account info, a "View Balance" action, and a quick-transfer button.
class AccountRow extends ConsumerWidget {
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

  void onQuickTransferPressed(BuildContext context, WidgetRef ref) {
    // Use Riverpod to set the selected bank account for transfer
    ref.read(transferNotifierProvider.notifier).selectFromBankAccount(bankAccount);
    Navigator.pushNamed(
      context,
      '/transfer/to',
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  _buildLabels(context, ref, bankAccount),
                ],
              ),
            ),
          ),

          const SizedBox(width: _spacing),

          // Quick-transfer button
          FlowButton(
            onPressed: () {
              onQuickTransferPressed(context, ref);
            },
            child: Container(
              width: 65,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFFF0F0F0)
                        : Theme.of(context).colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.swap_horiz,
                size: 24,
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF565656)
                        : const Color(0xFFAAAAAA),
              ),
            ),
          ),
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

  Widget _buildLabels(BuildContext context, WidgetRef ref, BankAccount bankAccount) {
    final showBalance = ref.watch(displayBalanceProvider);
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankAccount.accountName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF565656)
                      : const Color(0xFFCCCCCC),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            showBalance ? '\$ ${bankAccount.balance}' : 'View Balance',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}