import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';

class FlowTopBar extends StatelessWidget {
  final Widget title;
  final Widget leftWidget;

  const FlowTopBar({
    super.key,
    required this.title,
    this.leftWidget = const SizedBox(height: 20, width: 20),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlowButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/icons/previous.png',
                height: 20,
                width: 20,
              ),
            ),
            Expanded(child: title),
            leftWidget,
          ],
        ),
      ),
    );
  }
}
