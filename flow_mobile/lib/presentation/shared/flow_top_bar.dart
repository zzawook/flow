import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';

class FlowTopBar extends StatelessWidget {
  final Widget title;
  final Widget leftWidget;
  final bool showBackButton;

  static const Widget emptyBox = SizedBox(width: 20, height: 20);

  const FlowTopBar({
    super.key,
    required this.title,
    this.leftWidget = emptyBox,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showBackButton
                ? FlowButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/icons/previous.png',
                    height: 20,
                    width: 20,
                  ),
                )
                : emptyBox,
            Expanded(child: title),
            leftWidget,
          ],
        ),
      ),
    );
  }
}
