import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/paynow_recipient.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_receivable_state.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/account_layout.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/paynow_layout.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TransferToScreen extends StatefulWidget {
  const TransferToScreen({super.key});

  @override
  State<TransferToScreen> createState() => _TransferToScreenState();
}

class _TransferToScreenState extends State<TransferToScreen> {
  // Track which tab is selected: 0 => PayNow, 1 => Account
  int _selectedTabIndex = 0;

  // Controllers for text input
  final TextEditingController _payNowController = TextEditingController();

  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _selectBankController = TextEditingController();

  // FocusNodes for EditableText
  final FocusNode _payNowFocus = FocusNode();
  final FocusNode _accountNumberFocus = FocusNode();
  final FocusNode _selectBankFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: const Color(0xFFF5F5F5),
      child: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.only(
              top: 28,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Who's receiving?",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Inter",
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TabRowWidget(
            selectedTabIndex: _selectedTabIndex,
            onTabSelected: (int index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StoreConnector<
                FlowState,
                TransferReceivableAndBankAccountState
              >(
                converter:
                    (store) => TransferReceivableAndBankAccountState(
                      transferReceivableState:
                          store.state.transferReceivableState,
                      bankAccountState: store.state.bankAccountState,
                    ),
                builder: (context, transferReceivableAndBankAccountState) {
                  TransferReceivableState transferReceivableState =
                      transferReceivableAndBankAccountState
                          .transferReceivableState;
                  BankAccountState bankAccountState =
                      transferReceivableAndBankAccountState.bankAccountState;
                  final List<PayNowRecipient> recommended =
                      transferReceivableState.getRecommendedPayNow();
                  final List<PayNowRecipient> fromContacts =
                      transferReceivableState.getPayNowFromContactExcluding([]);
                  final List<BankAccount> recommendedBankAccount =
                      transferReceivableState.getRecommendedBankAccount();
                  final List<BankAccount> myBankAccounts =
                      bankAccountState.bankAccounts;
                  return Container(
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5)),
                    child:
                        _selectedTabIndex == 0
                            ? PayNowLayoutWidget(
                              payNowController: _payNowController,
                              payNowFocus: _payNowFocus,
                              recommended: recommended,
                              fromContact: fromContacts,
                            )
                            : AccountLayoutWidget(
                              accountNumberController: _accountNumberController,
                              accountNumberFocus: _accountNumberFocus,
                              selectBankController: _selectBankController,
                              selectBankFocus: _selectBankFocus,
                              myAccounts: myBankAccounts,
                              recommended: recommendedBankAccount,
                            ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferReceivableAndBankAccountState {
  final TransferReceivableState transferReceivableState;
  final BankAccountState bankAccountState;

  TransferReceivableAndBankAccountState({
    required this.transferReceivableState,
    required this.bankAccountState,
  });
}

class TabRowWidget extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;
  const TabRowWidget({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, right: 28),
      child: Container(
        color: const Color(0xFFECEFF1),
        child: Row(
          children: [
            TabItemWidget(
              title: "PayNow",
              index: 0,
              isSelected: selectedTabIndex == 0,
              onTap: onTabSelected,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            TabItemWidget(
              title: "Account",
              index: 1,
              isSelected: selectedTabIndex == 1,
              onTap: onTabSelected,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabItemWidget extends StatelessWidget {
  final String title;
  final int index;
  final bool isSelected;
  final ValueChanged<int> onTap;
  final BorderRadius borderRadius;

  const TabItemWidget({
    super.key,
    required this.title,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF50C878) : Color(0xFFFFFFFF),
            borderRadius: borderRadius,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xFFFFFFFF) : Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }
}
