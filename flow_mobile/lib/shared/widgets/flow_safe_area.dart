import 'package:flutter/material.dart';

class FlowSafeArea extends StatelessWidget {
  final Widget child;

  const FlowSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(bottom: false, child: child);
  }
}
