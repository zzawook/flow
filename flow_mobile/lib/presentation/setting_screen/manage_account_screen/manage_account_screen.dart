import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/auth_thunks.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/presentation/shared/flow_confirm_bottom_sheet.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flow_mobile/presentation/shared/flow_text_edit_bottom_sheet.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  void _onDeleteAccount(BuildContext context) {
    StoreProvider.of<FlowState>(
      context,
      listen: false,
    ).dispatch(DeleteUserAction());
    final nav = getIt<NavigationService>();
    nav.pushNamedAndRemoveUntil(AppRoutes.welcome);
  }

  void _onLogout(BuildContext context) {
    StoreProvider.of<FlowState>(context, listen: false).dispatch(logoutThunk());
  }

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
                  converter:
                      (store) => store.state.userState.user?.nickname ?? '',
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
                  child: FlowCTAButton(
                    fontWeight: FontWeight.normal,
                    text: 'Log out',
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (builder) {
                          return FlowConfirmBottomSheet(
                            title: "Are you sure you want to log out?",
                            message: "",
                            onConfirm: () {
                              _onLogout(context);
                            },
                            showCancelButton: false,
                            onCancel: () {},
                            confirmText: "Log out",
                            confirmTextColor: Colors.white,
                            confirmColor: Colors.red,
                            cancelColor: Colors.white,
                          );
                        },
                      );
                    },
                    color: Colors.transparent,
                    borderColor: Colors.red,
                  ),
                ),
                const FlowSeparatorBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: FlowCTAButton(
                    fontWeight: FontWeight.normal,
                    text: 'Delete Account',
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (builder) {
                          return FlowConfirmBottomSheet(
                            title:
                                "Are you sure you want to delete your account? \n\nThis action cannot be undone, \nand all your data wil be lost.",
                            message: "",
                            onConfirm: () {
                              _onDeleteAccount(context);
                            },
                            showCancelButton: false,
                            onCancel: () {},
                            confirmText: "I understand, DELETE my account",
                            confirmTextColor: Colors.white,
                            confirmColor: Colors.red,
                          );
                        },
                      );
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    borderColor: Colors.red,
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
