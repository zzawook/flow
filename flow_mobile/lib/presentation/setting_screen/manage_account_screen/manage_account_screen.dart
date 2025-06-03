import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flow_mobile/shared/widgets/flow_text_edit_bottom_sheet.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          // ── top bar ───────────────────────────────────────────────
          FlowTopBar(
            title: Center(
              child: Text(
                'Manage Account',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          // ── content area ───────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                StoreConnector<FlowState, String>(
                  converter: (store) => store.state.userState.user.nickname,
                  builder:
                      (context, nickname) => SettingTab(
                        title: 'Nickname',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              nickname,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(160),
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder:
                                (ctx) => FlowTextEditBottomSheet(
                                  title: 'Edit Nickname',
                                  initialValue:
                                      nickname, // Replace with state value as needed
                                  hintText: 'Enter new nickname',
                                  saveButtonText: 'Save',
                                  onSave: (newName) {
                                    StoreProvider.of<FlowState>(
                                      context,
                                    ).dispatch(
                                      UpdateUserNicknameAction(newName),
                                    );
                                  },
                                ),
                          );
                        },
                        indents: 0,
                        enabled: true,
                      ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FlowButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(160),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
