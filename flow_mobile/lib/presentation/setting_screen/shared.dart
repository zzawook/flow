import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flutter/material.dart';

class SettingTabWithIcon extends StatelessWidget {
  final String title;
  final Icon icon;
  final Widget trailing;
  final Function()? onTap;

  const SettingTabWithIcon({
    super.key,
    required this.title,
    required this.icon,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class SettingTab extends StatelessWidget {
  final String title;
  final Widget trailing;
  final Function()? onTap;
  final int indents;
  final bool enabled;
  final Widget? below;

  const SettingTab({
    super.key,
    required this.title,
    required this.trailing,
    required this.onTap,
    required this.indents,
    required this.enabled,
    this.below,
  });

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: 24,
          bottom: 8,
          right: 24,
          left: 12 + (indents * 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              enabled
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(128),
                        ),
                      ),
                      FlowSeparatorBox(height: 4),
                      if (below != null) below!,
                    ],
                  ),
                ),
                FlowSeparatorBox(width: 16),
                trailing,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
