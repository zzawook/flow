import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ToAccountsListWidget extends StatelessWidget {
  final List<TransferReceivable> accounts;
  const ToAccountsListWidget({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          accounts.map((bankAccount) {
            return ToAccountRow(transferReceivable: bankAccount);
          }).toList(),
    );
  }
}

class ToAccountRow extends StatelessWidget {
  const ToAccountRow({super.key, required this.transferReceivable});

  final TransferReceivable transferReceivable;

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        StoreProvider.of<FlowState>(
          context,
        ).dispatch(SelectToBankAccountAction(transferReceivable));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color(0xFFBDBDBD),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(transferReceivable.bank.logoPath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transferReceivable.name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transferReceivable.bank.name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
