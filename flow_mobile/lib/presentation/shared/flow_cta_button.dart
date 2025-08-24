import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FlowCTAButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  Color? color;
  Color? textColor;
  final double borderRadius;
  final FontWeight fontWeight;
  Color? borderColor;

  FlowCTAButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius = 16,
    this.fontWeight = FontWeight.bold,
    this.borderColor = Colors.transparent,
  });

  @override
  State<FlowCTAButton> createState() => _FlowCTAButtonState();
}

class _FlowCTAButtonState extends State<FlowCTAButton> {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return FlowButton(
      onPressed: widget.onPressed,
      child: Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color ?? primary,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor ?? Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          widget.text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color:
                widget.textColor ??
                Theme.of(context).textTheme.titleSmall?.color,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}
