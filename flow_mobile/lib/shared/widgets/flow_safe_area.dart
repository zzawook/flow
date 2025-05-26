import 'package:flutter/material.dart';

class FlowSafeArea extends StatelessWidget {
  final Widget child;
  Color? backgroundColor;

  FlowSafeArea({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: MediaQuery.of(context).padding.left,
        right: MediaQuery.of(context).padding.right,
      ),
      color: backgroundColor ?? Colors.transparent,
      child: child,
    );
  }
}
