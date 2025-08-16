import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flow_mobile/presentation/shared/flow_text_edit_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageAccountScreen extends ConsumerWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
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
                SettingTab(
                  title: 'Nickname',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.nickname,
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
                            initialValue: user.nickname,
                            hintText: 'Enter new nickname',
                            saveButtonText: 'Save',
                            onSave: (newName) {
                              final updatedUser = user.copyWith(nickname: newName);
                              ref.read(userNotifierProvider.notifier)
                                  .updateUser(updatedUser);
                            },
                          ),
                    );
                  },
                  indents: 0,
                  enabled: true,
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
