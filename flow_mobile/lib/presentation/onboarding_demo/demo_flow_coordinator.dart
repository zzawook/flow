import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/onboarding_demo/demo_screen_wrapper.dart';
import 'package:flutter/material.dart';

/// Coordinates the demo flow and provides interactive zone configurations
class DemoFlowCoordinator {
  /// Get interactive zones for FlowHomeScreen demo
  static List<InteractiveZoneConfig> getHomeScreenZones(
    BuildContext context,
    VoidCallback onNavigateToSpending,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final bottomNavHeight = 60.0;
    final screenHeight = screenSize.height;

    // Bottom nav "Spending" tab is roughly in the middle-left
    // Assuming 5 tabs, spending is the 2nd one (index 1)
    final tabWidth = screenSize.width / 5;
    final spendingTabLeft = tabWidth * 1; // Second tab (0-indexed)

    return [
      InteractiveZoneConfig(
        rect: Rect.fromLTWH(
          spendingTabLeft,
          screenHeight - bottomNavHeight,
          tabWidth,
          bottomNavHeight,
        ),
        onTap: onNavigateToSpending,
        showHint: true,
      ),
    ];
  }

  /// Get interactive zones for SpendingScreen Step 1
  static List<InteractiveZoneConfig> getSpendingScreenStep1Zones(
    BuildContext context,
    VoidCallback onNavigateToStep2,
  ) {
    final screenSize = MediaQuery.of(context).size;

    // "See Details" button in SpendingOverviewCard
    // This is typically around y=300-350 (below top bar + monthly overview title)
    // and spans most of the screen width with padding
    return [
      InteractiveZoneConfig(
        rect: Rect.fromLTWH(
          24, // left padding
          320, // approximate position of "See Details" button
          screenSize.width - 48, // width with padding
          50, // button height
        ),
        onTap: onNavigateToStep2,
        showHint: true,
      ),
    ];
  }

  /// Get interactive zones for SpendingScreen Step 2
  static List<InteractiveZoneConfig> getSpendingScreenStep2Zones(
    BuildContext context,
    VoidCallback onNavigateToStep3,
  ) {
    final screenSize = MediaQuery.of(context).size;

    // Interactive zone on a button in the middle section
    // This could be on the Trend Card or similar
    return [
      InteractiveZoneConfig(
        rect: Rect.fromLTWH(
          24,
          500, // approximate middle section
          screenSize.width - 48,
          50,
        ),
        onTap: onNavigateToStep3,
        showHint: true,
      ),
    ];
  }

  /// Get interactive zones for SpendingScreen Step 3
  static List<InteractiveZoneConfig> getSpendingScreenStep3Zones(
    BuildContext context,
    VoidCallback onNavigateToCalendar,
  ) {
    final screenSize = MediaQuery.of(context).size;

    // Interactive zone on a button near the bottom
    return [
      InteractiveZoneConfig(
        rect: Rect.fromLTWH(
          24,
          700, // lower section
          screenSize.width - 48,
          50,
        ),
        onTap: onNavigateToCalendar,
        showHint: true,
      ),
    ];
  }

  /// Get interactive zones for SpendingCalendarScreen
  static List<InteractiveZoneConfig> getSpendingCalendarZones(
    BuildContext context,
    VoidCallback onNavigateToAsset,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final bottomNavHeight = 60.0;
    final screenHeight = screenSize.height;

    // Bottom nav "Asset" tab is the last one (index 4 for 5 tabs)
    final tabWidth = screenSize.width / 5;
    final assetTabLeft = tabWidth * 4; // Fifth tab

    return [
      InteractiveZoneConfig(
        rect: Rect.fromLTWH(
          assetTabLeft,
          screenHeight - bottomNavHeight,
          tabWidth,
          bottomNavHeight,
        ),
        onTap: onNavigateToAsset,
        showHint: true,
      ),
    ];
  }

  /// Navigate to next demo screen
  static void navigateToNextDemoScreen(
    BuildContext context,
    String targetRoute,
  ) {
    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  /// Navigate and remove demo flow, going to final step
  static void completeDemoAndNavigateToDOB(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.signupDateOfBirth, (route) => false);
  }
}
