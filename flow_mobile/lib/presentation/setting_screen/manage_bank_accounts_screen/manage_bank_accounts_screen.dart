import 'package:flow_mobile/domain/entities/setting_v1.dart';
import 'package:flow_mobile/domain/redux/actions/setting_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ManageBankAccountsScreen extends StatefulWidget {
  const ManageBankAccountsScreen({super.key});

  @override
  State<ManageBankAccountsScreen> createState() =>
      _ManageBankAccountsScreenState();
}

class _ManageBankAccountsScreenState extends State<ManageBankAccountsScreen> {
  bool showBalanceOnHome = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    Widget settingsRow({required String label, required Widget trailing}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: onSurface, fontSize: 16)),
            trailing,
          ],
        ),
      );
    }

    return FlowSafeArea(
      backgroundColor: theme.canvasColor,
      child: Material(
        child: Column(
          children: [
            // ── top bar ───────────────────────────────────────────────
            FlowTopBar(
              title: Center(
                child: Text(
                  'Manage Bank Accounts',
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),

            // ── content area ───────────────────────────────────────────
            Expanded(
              child: StoreConnector<FlowState, bool>(
                converter: (store) {
                  SettingsV1 settings = store.state.settingsState.settings;
                  return settings.displayBalanceOnHome;
                },
                builder: (_, showBalanceOnHome) {
                  return Column(
                    children: [
                      settingsRow(
                        label: 'Show balance in Home Screen',
                        trailing: Switch.adaptive(
                          value: showBalanceOnHome,
                          onChanged:
                              (v) => StoreProvider.of<FlowState>(
                                context,
                              ).dispatch(ToggleDisplayBalanceOnHomeAction()),
                          activeColor: theme.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
