import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/account_layout.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/paynow_layout.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferToScreen extends ConsumerStatefulWidget {
  const TransferToScreen({super.key});

  @override
  ConsumerState<TransferToScreen> createState() => _TransferToScreenState();
}

class _TransferToScreenState extends ConsumerState<TransferToScreen> {
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
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          FlowTopBar(
            title: Center(
              child: Text(
                'Transfer',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
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
                    color: Theme.of(context).colorScheme.onSurface,
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
              child: Consumer(
                builder: (context, ref, child) {
                  final transferReceivableState = ref.watch(transferReceivableStateProvider);
                  final bankAccounts = ref.watch(bankAccountsProvider);
                  
                  final List<PayNowRecipient> recommended =
                      transferReceivableState.getRecommendedPayNow();
                  final List<PayNowRecipient> fromContacts =
                      transferReceivableState.getPayNowFromContactExcluding([]);
                  final List<BankAccount> recommendedBankAccount =
                      transferReceivableState.getRecommendedBankAccount();
                  final List<BankAccount> myBankAccounts = bankAccounts;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
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
            color:
                isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor.withAlpha(160),
            borderRadius: borderRadius,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  isSelected
                      ? Color(0xFFFFFFFF)
                      : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
