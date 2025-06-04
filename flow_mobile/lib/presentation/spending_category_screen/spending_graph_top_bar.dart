import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/widgets.dart';

class SpendingGraphTopBar extends StatelessWidget {
  const SpendingGraphTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
