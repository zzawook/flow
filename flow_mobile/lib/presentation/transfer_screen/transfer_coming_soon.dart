import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';

class TransferComingSoon extends StatelessWidget {
  const TransferComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          FlowTopBar(
            title: Center(
              child: Text(
                'Transfer',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            showBackButton: false,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Transfer feature is coming soon!'
                '\nStay tuned for updates.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          FlowBottomNavBar(),
        ],
      ),
    );
  }
}
