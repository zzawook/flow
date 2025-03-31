import 'package:flutter/widgets.dart';

class FlowHorizontalDivider extends StatelessWidget {
  const FlowHorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFEDEDED), width: 1.2),
      ),
    );
  }
}