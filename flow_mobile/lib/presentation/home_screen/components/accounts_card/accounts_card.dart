
import 'package:flow_mobile/presentation/home_screen/components/accounts_card/account_row.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A card listing the user's bank accounts, with a "See more" footer.
class AccountsCard extends ConsumerWidget {
  final VoidCallback onToggleBalance;

  const AccountsCard({super.key, required this.onToggleBalance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(bankAccountsProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // One row per account
          for (final account in accounts)
            if (!account.isHidden)
              AccountRow(
                bankAccount: account,
                onViewBalance: onToggleBalance,
              ),
          // "See more" button
          _SeeMoreButton(),
        ],
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
          children: [
            const Text(
              'See more about my accounts',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFFA6A6A6),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 12, color: Color(0xFFA19F9F)),
          ],
        ),
      ),
    );
  }
}