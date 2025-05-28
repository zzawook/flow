import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/refresh_screen/bank_tile.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_top_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RefreshInitScreen extends StatelessWidget {
  const RefreshInitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return StoreConnector<FlowState, List<BankData>>(
      converter: (store) {
        BankAccountState bankAccountState = store.state.bankAccountState;
        List<BankData> bankDatas = [];
        for (var bankAccount in bankAccountState.bankAccounts) {
          bool found = false;
          for (var bankData in bankDatas) {
            if (bankData.bank.name == bankAccount.bank.name) {
              bankData.accountNames.add(bankAccount.accountName);
              found = true;
              break;
            }
          }
          if (!found) {
            bankDatas.add(
              BankData(
                bank: bankAccount.bank,
                accountNames: [bankAccount.accountName],
              ),
            );
          }
        }
        return bankDatas;
      },
      builder:
          (context, bankDatas) => RefreshInitScreenContainer(
            screenSize: screenSize,
            bankDatas: bankDatas,
          ),
    );
  }
}

class RefreshInitScreenContainer extends StatefulWidget {
  const RefreshInitScreenContainer({
    super.key,
    required this.screenSize,
    required this.bankDatas,
  });

  final Size screenSize;
  final List<BankData> bankDatas;

  @override
  State<RefreshInitScreenContainer> createState() =>
      _RefreshInitScreenContainerState();
}

class _RefreshInitScreenContainerState
    extends State<RefreshInitScreenContainer> {
  late List<BankData> newBankDatas;

  @override
  void initState() {
    super.initState();
    newBankDatas =
        widget.bankDatas
            .map(
              (bankData) => BankData(
                bank: bankData.bank,
                accountNames: bankData.accountNames,
                isSelected: bankData.isSelected,
              ),
            )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).primaryColor);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RefreshTopBar(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  // Informative message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To refresh your data,\nwe need MFAs from ${newBankDatas.where((bankData) => bankData.isSelected).length} banks',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Takes less than ${newBankDatas.where((bankData) => bankData.isSelected).length} minutes',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  // Bank tiles list
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose banks to refresh:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...newBankDatas.map(
                        (bankData) => BankTile(
                          bank: bankData.bank,
                          bankAccountNames: bankData.accountNames,
                          isSelected: bankData.isSelected,
                          onTap: () {
                            setState(() {
                              newBankDatas =
                                  newBankDatas.map((data) {
                                    if (data.bank.name == bankData.bank.name) {
                                      return BankData(
                                        bank: data.bank,
                                        accountNames: data.accountNames,
                                        isSelected: !data.isSelected,
                                      );
                                    }
                                    return data;
                                  }).toList();
                            });
                            StoreProvider.of<FlowState>(
                              context,
                            ).dispatch(SelectBankAction(bankData.bank));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
            // CTA button
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FlowButton(
                onPressed: () {
                  if (newBankDatas
                      .where((bankData) => bankData.isSelected)
                      .isEmpty) {
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    "/refresh/",
                    arguments: CustomPageRouteArguments(
                      transitionType: TransitionType.slideTop,
                    ),
                  );
                  StoreProvider.of<FlowState>(context).dispatch(
                    InitSelectedBankAction(
                      newBankDatas
                          .where((bankData) => bankData.isSelected)
                          .map((bankData) => bankData.bank)
                          .toList(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              newBankDatas
                                      .where((bankData) => bankData.isSelected)
                                      .isEmpty
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Let\'s go',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
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

class BankData {
  final Bank bank;
  final List<String> accountNames;
  bool isSelected;

  BankData({
    required this.bank,
    required this.accountNames,
    this.isSelected = true,
  });
}
