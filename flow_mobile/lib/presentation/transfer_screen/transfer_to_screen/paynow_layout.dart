import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/to_account_list.dart';
import 'package:flow_mobile/domain/entity/paynow_recipient.dart';
import 'package:flutter/material.dart';

class PayNowLayoutWidget extends StatelessWidget {
  final TextEditingController payNowController;
  final FocusNode payNowFocus;
  final List<PayNowRecipient> recommended;
  final List<PayNowRecipient> fromContact;

  const PayNowLayoutWidget({
    super.key,
    required this.payNowController,
    required this.payNowFocus,
    required this.recommended,
    required this.fromContact,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditableTextWidget(
            controller: payNowController,
            focusNode: payNowFocus,
            hintText: "Phone Number / Contact Name",
            labelText: "Phone Number / Contact Name",
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 16),
          Text(
            "Recommended",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFFFFFFFF)
                      : Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          ToAccountsListWidget(transferReceivables: recommended),
          const SizedBox(height: 8),
          Text(
            "Contacts",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Color(0xFFFFFFFF)
                      : Color(0xFF000000),
            ),
          ),
          ToAccountsListWidget(transferReceivables: fromContact),
        ],
      ),
    );
  }
}
