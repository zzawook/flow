import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/home_screen/components/accounts_card/account_row.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// A section listing multiple accounts (e.g., DBS, UOB, etc.).
class AccountsCard extends StatefulWidget {
  final VoidCallback onToggleBalance;

  const AccountsCard({super.key, required this.onToggleBalance});

  @override
  State<AccountsCard> createState() => _AccountsCardState();
}

class _AccountsCardState extends State<AccountsCard> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      margin: const EdgeInsets.only(bottom: 15),
      child: StoreConnector<FlowState, List<BankAccount>>(
        converter: (store) => store.state.bankAccountState.bankAccounts,
        builder:
            (context, bankAccounts) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Generate an AccountRow for each account in the list.
                ...bankAccounts.map((account) {

                  return AccountRow(
                    bankAccount: account,
                    onViewBalance: widget.onToggleBalance,
                  );
                }),
                FlowButton(
                  onPressed: () {
                    // Handle navigation or show more account details.
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'See more about my accounts ',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFFA6A6A6),
                            fontSize: 16,
                          ),
                        ),
                        Image.asset(
                          'assets/icons/arrow_right.png',
                          width: 12,
                          height: 12,
                          color: const Color(0xFFA19F9F),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
