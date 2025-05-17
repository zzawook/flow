import 'dart:ui';

import 'package:flutter/material.dart';

class PrivacyProtector extends StatefulWidget {
  final Widget child;
  const PrivacyProtector({required this.child, super.key});

  @override
  PrivacyProtectorState createState() => PrivacyProtectorState();
}

class PrivacyProtectorState extends State<PrivacyProtector>
    with WidgetsBindingObserver {
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final hide =
        (state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused);
    if (hide != _hidden) {
      setState(() => _hidden = hide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_hidden)
          // Option A: solid cover
          // Positioned.fill(child: Container(color: Colors.black)),
          // Option B: blurred cover
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withAlpha(100)),
            ),
          ),
      ],
    );
  }
}
