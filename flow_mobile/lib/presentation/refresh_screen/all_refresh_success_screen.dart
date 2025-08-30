import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';

class AllRefreshSuccessScreen extends StatelessWidget {
  const AllRefreshSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String compliment1 = "All set!";

    String emote1 = "🏆";
    String emote2 = "🎯";
    String emote3 = "✅";
    String emote4 = "💯";
    String emote5 = "🚀";

    String selectedCompliment = // RANDOMLY SELECT A COMPLIMENT
    ([
      compliment1,
    ]..shuffle()).first;

    String selectedEmote = // RANDOMLY SELECT AN EMOTE
    ([
      emote1,
      emote2,
      emote3,
      emote4,
      emote5,
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
              "All banks refreshing successfully!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                selectedEmote,
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
              text: "Return to Home",
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
