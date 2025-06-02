import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/to_account_list.dart';
import 'package:flutter/material.dart';

class AccountLayoutWidget extends StatelessWidget {
  final TextEditingController accountNumberController;
  final FocusNode accountNumberFocus;
  final TextEditingController selectBankController;
  final FocusNode selectBankFocus;
  final List<BankAccount> myAccounts;
  final List<BankAccount> recommended;

  const AccountLayoutWidget({
    super.key,
    required this.accountNumberController,
    required this.accountNumberFocus,
    required this.selectBankController,
    required this.selectBankFocus,
    required this.myAccounts,
    required this.recommended,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          EditableTextWidget(
            controller: accountNumberController,
            focusNode: accountNumberFocus,
            hintText: "Account number",
            labelText: "Account Number",
          ),
          const SizedBox(height: 8),
          EditableTextWidget(
            controller: selectBankController,
            focusNode: selectBankFocus,
            hintText: "Bank name (e.g., DBS, UOB, OCBC)",
            labelText: "Bank",
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Text(
            "My accounts",
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
          ToAccountsListWidget(transferReceivables: myAccounts),
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
        ],
      ),
    );
  }
}
