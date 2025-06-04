import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColor ?? Colors.transparent,
      child: child,
    );
  }
}
