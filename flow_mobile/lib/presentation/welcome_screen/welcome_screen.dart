import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowTopBar(title: Text(""), showBackButton: false),
              Padding(
                padding: EdgeInsetsGeometry.only(left: 24, right: 24, top: 36),
                child: Text(
                  "Welcome to Flow",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 34
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                child: Text(
                  "Your personal finance companion",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 48),
                child: FlowCTAButton(
                  text: "Get Started",
                  onPressed: () {
                    final nav = getIt<NavigationService>();
                    nav.pushNamed(AppRoutes.login);
                  },
                ),
              ),
            ],
          ),

          IgnorePointer(
            child: Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/FLOW.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
