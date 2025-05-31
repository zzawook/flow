import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/redux/actions/setting_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/setting_screen/shared.dart';
import 'package:flow_mobile/shared/utils/cron_utils.dart';
import 'package:flow_mobile/shared/widgets/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ManageNotificationScreen extends StatelessWidget {
  const ManageNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, NotificationSetting>(
      converter: (store) => store.state.settingsState.settings.notification,
      builder:
          (context, notificationSetting) => FlowSafeArea(
            backgroundColor: Theme.of(context).canvasColor,
            child: Column(
              children: [
                // ── top bar ───────────────────────────────────────────────
                FlowTopBar(
                  title: Center(
                    child: Text(
                      'Manage Notifications',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      SettingTab(
                        enabled: true,
                        below: Text(
                          "Turn on/off for all types of notifications.",
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.labelMedium?.color?.withAlpha(150),
                          ),
                        ),
                        indents: 0,
                        title: 'Get Notifications',
                        trailing: ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 30.0,
                          cornerRadius: 12.0,
                          activeBgColors: [
                            [Theme.of(context).primaryColor],
                            [Theme.of(context).primaryColor],
                          ],
                          inactiveBgColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          activeFgColor: Colors.white,
                          inactiveFgColor:
                              Theme.of(context).textTheme.bodyLarge?.color,
                          initialLabelIndex:
                              notificationSetting.masterEnabled ? 0 : 1,
                          totalSwitches: 2,
                          labels: const ['', ''],
                          icons: const [
                            Icons.notifications,
                            Icons.notifications_off,
                          ],
                          iconSize: 28.0,
                          borderWidth: 2.0,
                          borderColor: [Colors.grey.shade400],
                          onToggle: (index) {
                            StoreProvider.of<FlowState>(
                              context,
                            ).dispatch(ToggleNotificationMasterAction());
                          },
                        ),
                        onTap: () {},
                      ),

                      notificationSetting.masterEnabled
                          ? Column(
                            children: [
                              SettingTab(
                                enabled: notificationSetting.masterEnabled,
                                below: Text(
                                  "Analysis of your spending habits and patterns.",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.color
                                        ?.withAlpha(150),
                                  ),
                                ),
                                indents: 1,
                                title: 'Insight Notifications',
                                trailing: NotificationToggleSwitch(
                                  isEnabled:
                                      notificationSetting
                                          .insightNotificationEnabled,
                                  onToggle: (toggleStatus) {
                                    StoreProvider.of<FlowState>(
                                      context,
                                    ).dispatch(
                                      ToggleInsightNotificationAction(),
                                    );
                                  },
                                ),
                                onTap: () {},
                              ),
                              SettingTab(
                                enabled: notificationSetting.masterEnabled,
                                indents: 1,
                                title: 'Periodic Reminders',
                                below: Text(
                                  "Reminds you to track your expenses periodically.",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.color
                                        ?.withAlpha(150),
                                  ),
                                ),
                                trailing: NotificationToggleSwitch(
                                  isEnabled:
                                      notificationSetting
                                          .periodicNotificationEnabled,
                                  onToggle: (toggleStatus) {
                                    StoreProvider.of<FlowState>(
                                      context,
                                    ).dispatch(
                                      TogglePeriodicReminderNotificationAction(),
                                    );
                                  },
                                ),
                                onTap: () {},
                              ),
                              notificationSetting.masterEnabled &&
                                      notificationSetting
                                          .periodicNotificationEnabled
                                  ? Column(
                                    children: [
                                      SettingTab(
                                        enabled:
                                            notificationSetting.masterEnabled,
                                        indents: 2,
                                        title: 'Auto Periodic Reminders',
                                        below: Text(
                                          "Flow will automatically send you periodic reminders to track your expenses.",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.color
                                                ?.withAlpha(150),
                                          ),
                                        ),
                                        trailing: NotificationToggleSwitch(
                                          isEnabled:
                                              notificationSetting
                                                  .periodicNotificationAutoEnabled,
                                          onToggle: (toggleStatus) {
                                            StoreProvider.of<FlowState>(
                                              context,
                                            ).dispatch(
                                              TogglePeriodicReminderAutoNotificationAction(),
                                            );
                                          },
                                        ),
                                        onTap: () {},
                                      ),
                                      !notificationSetting
                                              .periodicNotificationAutoEnabled
                                          ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16,
                                              left: 72,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Custom Notification Intervals",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onSurface,
                                                      ),
                                                ),
                                                ...notificationSetting
                                                    .periodicNotificationCron
                                                    .map((cron) {
                                                      return PeriodicNotificationIntervalTab(
                                                        cron: cron,
                                                      );
                                                    }),
                                              ],
                                            ),
                                          )
                                          : const SizedBox(),
                                    ],
                                  )
                                  : const SizedBox(),
                            ],
                          )
                          : const SizedBox(),
                    ],
                  ),
                ),
                FlowBottomNavBar(),
              ],
            ),
          ),
    );
  }
}

class PeriodicNotificationIntervalTab extends StatelessWidget {
  final String cron;

  const PeriodicNotificationIntervalTab({super.key, required this.cron});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            CronUtils.cronToHuman(cron),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          FlowButton(
            onPressed: () {},
            child: Icon(Icons.delete, color: Colors.red.shade300),
          ),
        ],
      ),
    );
  }
}

class NotificationToggleSwitch extends StatelessWidget {
  final bool isEnabled;
  final Function(bool) onToggle;

  const NotificationToggleSwitch({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 50.0,
      minHeight: 30.0,
      cornerRadius: 12.0,
      activeBgColors: [
        [Theme.of(context).primaryColor],
        [Theme.of(context).primaryColor],
      ],
      inactiveBgColor: Theme.of(context).scaffoldBackgroundColor,
      activeFgColor: Colors.white,
      inactiveFgColor: Theme.of(context).textTheme.bodyLarge?.color,
      initialLabelIndex: isEnabled ? 0 : 1,
      totalSwitches: 2,
      labels: const ['', ''],
      icons: const [Icons.notifications, Icons.notifications_off],
      iconSize: 28.0,
      borderWidth: 2.0,
      borderColor: [Colors.grey.shade400],
      onToggle: (index) {
        if (index != null) {
          onToggle(index == 0);
        }
      },
    );
  }
}
