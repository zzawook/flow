import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flow_mobile/presentation/refresh_screen/bank_tile.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddAccountScreen extends StatefulWidget {
  final List<Bank> banks;
  const AddAccountScreen({super.key, required this.banks});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  List<Bank> selectedBanks = [];

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlowTopBar(title: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 48,
              top: 50,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose bank to link',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    for (var bank in widget.banks) ...[
                      BankTile(
                        bank: bank,
                        bankAccountNames: [],
                        isSelected: false,
                        onTap: () {
                          setState(() {
                            if (selectedBanks.contains(bank)) {
                              selectedBanks.remove(bank);
                            } else {
                              selectedBanks.add(bank);
                            }
                          });
                          StoreProvider.of<FlowState>(
                            context,
                            listen: false,
                          ).dispatch(SelectBankAction(bank));
                        },
                        shouldDisplayAccountDetails: false,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: StoreConnector<FlowState, List<Bank>>(
              converter: (store) {
                return store
                    .state
                    .screenState
                    .refreshScreenState
                    .banksToRefresh;
              },
              builder: (context, banks) {
                return FlowCTAButton(
                  text: 'Continue',
                  color: banks.isEmpty ? Colors.grey : null,
                  onPressed:
                      banks.isEmpty
                          ? () {}
                          : () {
                          StoreProvider.of<FlowState>(
                            context,
                            listen: false,
                          ).dispatch(
                            InitSelectedBankAction(selectedBanks),
                          ); // UPDATE REFRESH STATE WITH FULL SELECTED BANKS
                            StoreProvider.of<FlowState>(
                              context,
                              listen: false,
                            ).dispatch(linkBankThunk());
                          },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
