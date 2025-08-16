import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_horizontal_divider.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/shared/transfer/account_tile.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferScreen extends ConsumerWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final bankAccounts = ref.watch(bankAccountsProvider);

    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          // ── top bar ───────────────────────────────────────────────
          FlowTopBar(
            title: Center(
              child: Text(
                'Transfer',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          // ── static header section ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // greeting + balance
                Text(
                  'Hi ${user.nickname},',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Your total balance: ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      '\$4,869.17',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                FlowHorizontalDivider(),
                const SizedBox(height: 24),

                Text(
                  'Choose my bank account to transfer',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const FlowSeparatorBox(height: 6),
                Text(
                  'From:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const FlowSeparatorBox(height: 16),
              ],
            ),
          ),

          // ── scrollable list with pull-to-refresh ─────────────────
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () {
                Navigator.pushNamed(
                  context,
                  '/refresh',
                  arguments: CustomPageRouteArguments(
                    transitionType: TransitionType.slideTop,
                  ),
                );
                return Future.delayed(const Duration(microseconds: 1));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: bankAccounts.length,
                itemBuilder: (_, index) {
                  final bankAccount = bankAccounts[index];
                  return AccountTile(
                    bankAccount: bankAccount,
                    onTransferPressed: () {
                      ref.read(transferNotifierProvider.notifier)
                          .selectFromBankAccount(bankAccount);
                      Navigator.pushNamed(context, '/transfer/to');
                    },
                  );
                },
              ),
            ),
          ),
          FlowBottomNavBar(),
        ],
      ),
    );
  }
}
