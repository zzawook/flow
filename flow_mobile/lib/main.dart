import 'package:flow_mobile/home/flow_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlowApplication());
}

class FlowApplication extends StatelessWidget {
  const FlowApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Flow',
      builder: (context, child) => const FlowHomeScreen(),
      color: const Color(0xFFFFFFFF),
    );
  }
}
