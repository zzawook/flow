import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/setting_thunks.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_horizontal_divider.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
                'Settings',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            showBackButton: false,
          ),

          // ── static header section ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // greeting + balance
                StoreConnector<FlowState, String>(
                  converter:
                      (store) =>
                          store.state.userState.user?.nickname ??
                          'NOT_LOGGED_IN',
                  builder: (_, name) {
                    if (name == 'NOT_LOGGED_IN') {
                      return FlowCTAButton(
                        text: "Log in / Sign up",
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/login',
                            arguments: CustomPageRouteArguments(
                              transitionType: TransitionType.slideLeft,
                            ),
                          );
                        },
                      );
                    }
                    return Text(
                      'Hi $name',
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  },
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
                    Navigator.pushNamed(
                      context,
                      '/account/setting',
                      arguments: CustomPageRouteArguments(
                        transitionType: TransitionType.slideLeft,
                      ),
                    );
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
                    Navigator.pushNamed(
                      context,
                      '/bank_accounts/setting',
                      arguments: CustomPageRouteArguments(
                        transitionType: TransitionType.slideLeft,
                      ),
                    );
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
                    Navigator.pushNamed(
                      context,
                      '/notification/setting',
                      arguments: CustomPageRouteArguments(
                        transitionType: TransitionType.slideLeft,
                      ),
                    );
                  },
                ),

                SettingTabWithIcon(
                  title: 'Theme',
                  icon: Icon(
                    Icons.color_lens,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: StoreConnector<FlowState, String>(
                    converter:
                        (store) => store.state.settingsState.settings.theme,
                    builder:
                        (context, theme) => ThemeToggleSwitch(
                          currentIndex: theme == 'light' ? 0 : 1,
                          onToggle: (index) {
                            if (index != null) {
                              StoreProvider.of<FlowState>(
                                context,
                              ).dispatch(
                            updateThemeAction(index == 0 ? 'light' : 'dark'),
                          );
                            }
                          },
                        ),
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
      minWidth: 35.0,
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
