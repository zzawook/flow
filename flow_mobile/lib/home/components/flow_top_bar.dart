/* -------------------------------------------------------------------------- */
/*                                FlowTopBar                                  */
/* -------------------------------------------------------------------------- */

import 'package:flutter/widgets.dart';

/// A simple top bar with a logo and a notification icon.
class FlowTopBar extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const FlowTopBar({super.key, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/FLOW.png', height: 80, width: 80),
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'assets/icons/notification_icon.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
