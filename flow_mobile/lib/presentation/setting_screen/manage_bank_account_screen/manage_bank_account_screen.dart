import 'package:flow_mobile/shared/widgets/flow_safe_area.dart';
import 'package:flow_mobile/shared/widgets/flow_top_bar.dart';
import 'package:flutter/material.dart';

class ManageBankAccountScreen extends StatelessWidget {
  const ManageBankAccountScreen({super.key});

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
                'Manage Bank Account',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          // ── content area ───────────────────────────────────────────
          Expanded(
            child: Center(
              child: Text(
                'This feature is under development.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
