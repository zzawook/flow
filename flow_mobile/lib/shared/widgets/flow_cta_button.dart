import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/widgets.dart';

class FlowCTAButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final FontWeight fontWeight;

  const FlowCTAButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF50C878),
    this.textColor = const Color(0xFFFFFFFF),
    this.borderRadius = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: onPressed,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
