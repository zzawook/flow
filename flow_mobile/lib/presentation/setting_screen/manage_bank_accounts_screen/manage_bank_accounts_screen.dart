import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageBankAccountsScreen extends ConsumerStatefulWidget {
  const ManageBankAccountsScreen({super.key});

  @override
  ConsumerState<ManageBankAccountsScreen> createState() =>
      _ManageBankAccountsScreenState();
}

class _ManageBankAccountsScreenState extends ConsumerState<ManageBankAccountsScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              child: Consumer(
                builder: (context, ref, child) {
                  final settingsState = ref.watch(settingsStateProvider);
                  final showBalanceOnHome = settingsState.settings.displayBalanceOnHome;
                  
                  return Column(
                    children: [
                      SettingTab(
                        title: 'Show balance in Home Screen',
                        trailing: Switch.adaptive(
                          value: showBalanceOnHome,
                          onChanged: (v) => ref.read(settingsNotifierProvider.notifier)
                              .toggleDisplayBalanceOnHome(),
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
