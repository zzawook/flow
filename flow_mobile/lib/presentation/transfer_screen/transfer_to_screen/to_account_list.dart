import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ToAccountsListWidget extends StatelessWidget {
  final List<TransferReceivable> transferReceivables;
  const ToAccountsListWidget({super.key, required this.transferReceivables});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          transferReceivables.map((transferReceivable) {
            return ToAccountRow(transferReceivable: transferReceivable);
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
        ).dispatch(SelectTransferRecipientAction(transferReceivable));
        Navigator.pushNamed(
          context,
          '/transfer/amount',
          arguments: CustomPageRouteArguments(
            transitionType: TransitionType.slideLeft,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        decoration: BoxDecoration(
          // color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration:
                  transferReceivable.isPayNow
                      ? null
                      : BoxDecoration(
                        // color: Color(0xFFBDBDBD),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                transferReceivable.isPayNow
                    ? "assets/bank_logos/paynow.png"
                    : transferReceivable.bank.logoPath,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transferReceivable.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transferReceivable.isPayNow
                        ? '${transferReceivable.identifier} (PayNow)'
                        : '${transferReceivable.bank.name} - ${transferReceivable.identifier}',
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
