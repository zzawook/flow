import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/widgets.dart';

class TransferTopBar extends StatelessWidget {
  const TransferTopBar({super.key, required this.previousScreenRoute});

  final String previousScreenRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlowButton(
          onPressed: () {
            Navigator.pushNamed(context, previousScreenRoute);
          },
          child: Image.asset(
            'assets/icons/previous.png',
            height: 20,
            width: 20,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Transfer',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ),
        Image.asset('assets/icons/camera.png', height: 25, width: 25),
      ],
    );
  }
}
