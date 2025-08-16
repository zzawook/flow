import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

void main() {
  group('FlowBottomNavBar Widget Tests', () {
    testWidgets('should render all navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Verify all navigation items are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Spending'), findsOneWidget);
      expect(find.text('Asset'), findsOneWidget);
      expect(find.text('Transfer'), findsOneWidget);
      expect(find.text('Setting'), findsOneWidget);

      // Verify all icons are present
      expect(find.byType(Image), findsNWidgets(5));
    });

    testWidgets('should highlight home item when on home screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                onSurface: Colors.black,
              ),
              disabledColor: Colors.grey,
            ),
            home: const Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Find all images (icons)
      final images = tester.widgetList<Image>(find.byType(Image));
      final homeImage = images.first;
      
      // Verify home icon has selected color (should not be grey)
      expect(homeImage.color, isNot(equals(Colors.grey)));
    });

    testWidgets('should highlight spending item when on spending screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/spending'),
          ],
          child: MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                onSurface: Colors.black,
              ),
              disabledColor: Colors.grey,
            ),
            home: const Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Find spending text and verify it's highlighted
      final spendingText = tester.widget<Text>(find.text('Spending'));
      expect(spendingText.style?.color, isNot(equals(Colors.grey)));
    });

    testWidgets('should have correct container height and styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minHeight, equals(84));

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )));
    });

    testWidgets('should handle navigation tap without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Tap on spending item
      await tester.tap(find.text('Spending'));
      await tester.pump();

      // Should not throw any errors
      expect(find.byType(FlowBottomNavBar), findsOneWidget);
    });

    testWidgets('should not navigate when already on the same screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Tap on home item (already on home screen)
      await tester.tap(find.text('Home'));
      await tester.pump();

      // Should not cause any issues
      expect(find.byType(FlowBottomNavBar), findsOneWidget);
    });

    testWidgets('should show correct icon assets', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      
      // Verify correct asset paths
      expect((images[0].image as AssetImage).assetName, equals('assets/icons/home_icon.png'));
      expect((images[1].image as AssetImage).assetName, equals('assets/icons/spending_icon.png'));
      expect((images[2].image as AssetImage).assetName, equals('assets/icons/asset_icon.png'));
      expect((images[3].image as AssetImage).assetName, equals('assets/icons/transfer_icon.png'));
      expect((images[4].image as AssetImage).assetName, equals('assets/icons/setting_icon.png'));
    });

    testWidgets('should have correct icon dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      final images = tester.widgetList<Image>(find.byType(Image));
      for (final image in images) {
        expect(image.height, equals(25));
        expect(image.width, equals(25));
      }
    });

    testWidgets('should highlight setting item for setting-related screens', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/setting/profile'),
          ],
          child: MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                onSurface: Colors.black,
              ),
              disabledColor: Colors.grey,
            ),
            home: const Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Find setting text and verify it's highlighted
      final settingText = tester.widget<Text>(find.text('Setting'));
      expect(settingText.style?.color, isNot(equals(Colors.grey)));
    });

    testWidgets('should highlight setting item for manage-related screens', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/manage/accounts'),
          ],
          child: MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                onSurface: Colors.black,
              ),
              disabledColor: Colors.grey,
            ),
            home: const Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      // Find setting text and verify it's highlighted
      final settingText = tester.widget<Text>(find.text('Setting'));
      expect(settingText.style?.color, isNot(equals(Colors.grey)));
    });

    testWidgets('should have proper padding and layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowBottomNavBar(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, equals(const EdgeInsets.only(bottom: 16)));

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.spaceEvenly));
      expect(row.mainAxisSize, equals(MainAxisSize.max));
    });
  });
}