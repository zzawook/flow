import 'package:flutter_test/flutter_test.dart';

// Import all widget test files
import 'shared/flow_button_test.dart' as flow_button_test;
import 'shared/flow_cta_button_test.dart' as flow_cta_button_test;
import 'shared/flow_top_bar_test.dart' as flow_top_bar_test;
import 'shared/flow_bottom_nav_bar_test.dart' as flow_bottom_nav_bar_test;
import 'shared/month_selector_test.dart' as month_selector_test;
import 'shared/error_display_widget_test.dart' as error_display_widget_test;
import 'shared/flow_safe_area_test.dart' as flow_safe_area_test;
import 'shared/flow_separator_box_test.dart' as flow_separator_box_test;
import 'shared/flow_horizontal_divider_test.dart' as flow_horizontal_divider_test;
import 'home_screen_test.dart' as home_screen_test;
import 'settings_screen_test.dart' as settings_screen_test;
import 'spending_screen_test.dart' as spending_screen_test;
import 'transfer_screen_test.dart' as transfer_screen_test;
import 'asset_screen_test.dart' as asset_screen_test;
import 'notification_screen_test.dart' as notification_screen_test;

/// Comprehensive widget test suite for all UI components and screens
/// 
/// This test suite covers:
/// - All shared UI components (buttons, navigation, layout widgets)
/// - All main application screens
/// - Error handling and state management widgets
/// - Visual regression testing for UI consistency
/// 
/// Run with: flutter test test/presentation/widget_test_suite.dart
void main() {
  group('Widget Test Suite - Complete UI Component Testing', () {
    group('Shared Components', () {
      group('Button Components', () {
        flow_button_test.main();
        flow_cta_button_test.main();
      });

      group('Navigation Components', () {
        flow_top_bar_test.main();
        flow_bottom_nav_bar_test.main();
      });

      group('Layout Components', () {
        flow_safe_area_test.main();
        flow_separator_box_test.main();
        flow_horizontal_divider_test.main();
      });

      group('Interactive Components', () {
        month_selector_test.main();
      });

      group('State Management Components', () {
        error_display_widget_test.main();
      });
    });

    group('Screen Components', () {
      group('Main Application Screens', () {
        home_screen_test.main();
        spending_screen_test.main();
        transfer_screen_test.main();
        asset_screen_test.main();
      });

      group('Settings and Configuration Screens', () {
        settings_screen_test.main();
        notification_screen_test.main();
      });
    });
  });
}