import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_text_edit_bottom_sheet.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RefreshSuccessScreen extends StatelessWidget {
  final Bank bank;

  const RefreshSuccessScreen({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    String compliment1 = "Lovely job!";
    String compliment2 = "You rock!";
    String compliment3 = "Fantastic work!";
    String compliment4 = "Way to go!";
    String compliment5 = "Brilliant!";

    String selectedCompliment = // RANDOMLY SELECT A COMPLIMENT
        ([compliment1, compliment2, compliment3, compliment4, compliment5]
          ..shuffle()).first;

    return Material(
      child: Scaffold(
        body: FlowSafeArea(
          backgroundColor: Theme.of(context).canvasColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowTopBar(title: Text(""), showBackButton: false),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  selectedCompliment,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8),
                child: Text(
                  "Refresh successful for ${bank.name}!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    "🎉",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(fontSize: 150),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: StoreConnector<FlowState, String?>(
                  converter: (store) => store
                      .state
                      .screenState
                      .refreshScreenState
                      .bankLoginMemo[bank.bankId.toString()],
                  builder: (context, vm) => FlowCTAButton(
                    text: "Leave a memo for next time",
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(
                          context,
                        ).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (ctx) => FlowTextEditBottomSheet(
                          title:
                              'Leave a memo for yourself to help you remember next time',
                          initialValue:
                              "", // Replace with state value as needed
                          hintText: 'Enter memo',
                          saveButtonText: 'Save',
                          onSave: (newMemo) async {
                            final apiService = getIt<ApiService>();
                            final result = await apiService
                                .updateLoginMemoForBank(bank, newMemo);

                            if (!result.success) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to save memo.'),
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                StoreProvider.of<FlowState>(
                                  context,
                                  listen: false,
                                ).dispatch(
                                  UpdateBankLoginMemoAction(
                                    bank: bank,
                                    memo: newMemo,
                                  ),
                                );
                                StoreProvider.of<FlowState>(
                                  context,
                                  listen: false,
                                ).dispatch(linkBankThunk());
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 36.0,
                  top: 12.0,
                ),
                child: FlowCTAButton(
                  text: "Continue",
                  onPressed: () {
                    StoreProvider.of<FlowState>(
                      context,
                      listen: false,
                    ).dispatch(linkBankThunk());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
