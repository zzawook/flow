import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class FlowCTAButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  Color? color;
  final Color textColor;
  final double borderRadius;
  final FontWeight fontWeight;

  FlowCTAButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor = const Color(0xFFFFFFFF),
    this.borderRadius = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  State<FlowCTAButton> createState() => _FlowCTAButtonState();
}

class _FlowCTAButtonState extends State<FlowCTAButton> {
  @override
  void initState() {
    super.initState();
    widget.color ??= Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: widget.onPressed,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            color: widget.textColor,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}
