import 'dart:async';

import 'package:flutter/widgets.dart';

class FlowButton extends StatefulWidget {
  final dynamic onPressed;
  final Widget child;

  const FlowButton({super.key, required this.onPressed, required this.child});

  @override
  FlowButtonState createState() => FlowButtonState();
}

class FlowButtonState extends State<FlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap:
          () => {
            widget.onPressed(),
            setState(() => _pressed = true),
            Timer(
              Duration(milliseconds: 50),
              () => setState(() => _pressed = false),
            ),
          },
      child: AnimatedScale(
        scale: _pressed ? 0.99 : 1.0,
        duration: Duration(milliseconds: 50),
        alignment: Alignment.center,
        child: ClipRect(
          child: ColorFiltered(
            colorFilter:
                _pressed
                    ? ColorFilter.mode(
                      Color(0xFF000000).withValues(alpha: 250),
                      BlendMode.darken,
                    )
                    : ColorFilter.mode(Color(0x00000000), BlendMode.darken),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
