import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';

class FlowTopBar extends StatelessWidget {
  final Text title;

  const FlowTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 72, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlowButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/previous.png',
              width: 20,
              height: 20,
            ),
          ),
          Expanded(
            child: title
          ),
          Image.asset('assets/icons/setting.png', width: 22, height: 22),
        ],
      ),
    );
  }
}
