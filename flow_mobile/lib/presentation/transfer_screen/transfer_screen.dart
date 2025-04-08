import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_horizontal_divider.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_top_bar.dart';
import 'package:flow_mobile/shared/widgets/transfer/account_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Directionality so text is laid out properly (LTR or RTL).
    return RefreshIndicator(
      onRefresh: () {
        Navigator.pushNamed(context, "/refresh");
        return Future.delayed(const Duration(microseconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              // A simple “app bar” row with a centered title:
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                    top: 72.0,
                  ),
                  child: Column(
                    children: [
                      TransferTopBar(previousScreenRoute: "/home"),

                      const SizedBox(height: 30),
                      // User info
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StoreConnector<FlowState, String>(
                              converter:
                                  (store) => store.state.userState.user.name,
                              builder: (context, name) {
                                return Text(
                                  'Hi $name,',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Your total balance: ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF50C878),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '\$4,869.17',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF50C878),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      FlowHorizontalDivider(),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose my bank account to transfer',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xAA000000),
                                ),
                              ),
                              FlowSeparatorBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    'From:',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      FlowSeparatorBox(height: 16),

                      Expanded(
                        child: StoreConnector<FlowState, List<BankAccount>>(
                          converter:
                              (store) =>
                                  store.state.bankAccountState.bankAccounts,
                          builder: (context, bankAccounts) {
                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 0, right: 0),
                              itemCount: bankAccounts.length,
                              itemBuilder: (context, index) {
                                final bankAccount = bankAccounts[index];
                                return AccountTile(
                                  bankAccount: bankAccount,
                                  onTransferPressed: () {
                                    StoreProvider.of<FlowState>(
                                      context,
                                    ).dispatch(
                                      SelectFromBankAccountAction(bankAccount),
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      '/transfer/to',
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FlowBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
