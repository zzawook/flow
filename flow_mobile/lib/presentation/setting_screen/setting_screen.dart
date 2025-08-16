import 'package:flow_mobile/presentation/navigation/app_navigation.dart';
import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_horizontal_divider.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = ref.watch(themeProvider);
    
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          // ── top bar ───────────────────────────────────────────────
          FlowTopBar(
            title: Center(
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          // ── static header section ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // greeting + balance
                Text(
                  'Hi ${user.nickname},',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 24),
                FlowHorizontalDivider(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SettingTabWithIcon(
                  title: 'Account',
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppNavigation.goToAccountSettings(context);
                  },
                ),
                SettingTabWithIcon(
                  title: 'Bank Account',
                  icon: Icon(
                    Icons.account_balance,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppNavigation.goToBankAccountsSettings(context);
                  },
                ),

                SettingTabWithIcon(
                  title: "Notification",
                  icon: Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    AppNavigation.goToNotificationSettings(context);
                  },
                ),

                SettingTabWithIcon(
                  title: 'Theme',
                  icon: Icon(
                    Icons.color_lens,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: ThemeToggleSwitch(
                    currentIndex: theme == 'light' ? 0 : 1,
                    onToggle: (index) {
                      if (index != null) {
                        ref.read(settingsNotifierProvider.notifier).toggleTheme();
                      }
                    },
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          FlowBottomNavBar(),
        ],
      ),
    );
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  final int currentIndex;
  final void Function(int?) onToggle;

  const ThemeToggleSwitch({
    super.key,
    required this.currentIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Colors for the “active” background. You can tweak these as desired.
    final activeBg = [
      // When “Light” is active, show a bright accent.
      [Colors.orange.shade200],
      // When “Dark” is active, show a moody blue‐gray.
      [Colors.blueGrey.shade700],
    ];

    return ToggleSwitch(
      minWidth: 50.0,
      minHeight: 30.0,
      cornerRadius: 12.0,
      activeBgColors: activeBg,
      inactiveBgColor: Theme.of(context).scaffoldBackgroundColor,
      activeFgColor: Colors.white,
      inactiveFgColor: Theme.of(context).textTheme.bodyLarge?.color,
      initialLabelIndex: currentIndex,
      totalSwitches: 2,
      // You can either provide `labels: ['Light', 'Dark']` or custom widgets:
      labels: const ['', ''], // leave blank since we use icons
      // Instead of `labels` or `customTexts`, we’ll override with `icons`
      icons: const [Icons.wb_sunny, Icons.nightlight_round],
      iconSize: 28.0,
      borderWidth: 2.0,
      borderColor: [Colors.grey.shade400],
      onToggle: (index) {
        onToggle(index);
      },
    );
  }
}
