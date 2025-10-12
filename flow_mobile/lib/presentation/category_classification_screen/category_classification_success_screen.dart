import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';

class CategoryClassificationSuccessScreen extends StatelessWidget {
  const CategoryClassificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String compliment1 = "All transactions categorized!";

    String selectedCompliment = // RANDOMLY SELECT A COMPLIMENT
    ([
      compliment1,
    ]..shuffle()).first;

    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlowTopBar(title: Text(""), showBackButton: false),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              selectedCompliment,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 8),
            child: Text(
              "You're all set!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                "🎉",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 150),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: FlowCTAButton(
              text: "Continue",
              onPressed: () {
                final navService = getIt<NavigationService>();
                navService.pushNamed(AppRoutes.spending);
              },
            ),
          ),
        ],
      ),
    );
  }
}
