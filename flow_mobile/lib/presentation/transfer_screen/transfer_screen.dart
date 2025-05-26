import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_horizontal_divider.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flow_mobile/shared/widgets/transfer/account_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          // ── top bar ───────────────────────────────────────────────
          FlowTopBar(
            title: const Center(
              child: Text(
                'Transfer',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                StoreConnector<FlowState, String>(
                  converter: (store) => store.state.userState.user.name,
                  builder:
                      (_, name) => Text(
                        'Hi $name,',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text(
                      'Your total balance: ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFF50C878),
                      ),
                    ),
                    Text(
                      '\$4,869.17',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF50C878),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                FlowHorizontalDivider(),
                const SizedBox(height: 24),

                const Text(
                  'Choose my bank account to transfer',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xAA000000),
                  ),
                ),
                const FlowSeparatorBox(height: 6),
                const Text(
                  'From:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
              child: StoreConnector<FlowState, List<BankAccount>>(
                converter: (store) => store.state.bankAccountState.bankAccounts,
                builder:
                    (_, bankAccounts) => ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: bankAccounts.length,
                      itemBuilder: (_, index) {
                        final bankAccount = bankAccounts[index];
                        return AccountTile(
                          bankAccount: bankAccount,
                          onTransferPressed: () {
                            StoreProvider.of<FlowState>(context).dispatch(
                              SelectFromBankAccountAction(bankAccount),
                            );
                            Navigator.pushNamed(context, '/transfer/to');
                          },
                        );
                      },
                    ),
              ),
            ),
          ),
          FlowBottomNavBar(),
        ],
      ),
    );
  }
}
