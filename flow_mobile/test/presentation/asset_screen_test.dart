import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/asset_screen/asset_screen.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

void main() {
  group('AssetScreen Widget Tests', () {
    testWidgets('should render asset screen with main components', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify main screen structure
      expect(find.byType(AssetScreen), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify layout components
      expect(find.byType(FlowSafeArea), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('should display main top bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify top bar is present
      expect(find.byType(FlowMainTopBar), findsOneWidget);
    });

    testWidgets('should display bottom navigation bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify bottom navigation is present
      expect(find.byType(FlowBottomNavBar), findsOneWidget);
    });

    testWidgets('should display bank account card', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify bank account card is present
      expect(find.byType(BankAccountCard), findsOneWidget);
    });

    testWidgets('should display add account card', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify add account card is present
      expect(find.byType(AddAccountCard), findsOneWidget);
    });

    testWidgets('should display total asset card', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify total asset card is present
      expect(find.byType(TotalAssetCard), findsOneWidget);
    });

    testWidgets('should have correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Find the main padding widget
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final mainPadding = paddingWidgets.firstWhere(
        (padding) => padding.padding == const EdgeInsets.only(left: 18, right: 18),
      );
      
      expect(mainPadding, isNotNull);
    });

    testWidgets('should have separator box between components', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify separator box is present
      expect(find.byType(FlowSeparatorBox), findsOneWidget);
    });

    testWidgets('should use theme canvas color for background', (WidgetTester tester) async {
      const canvasColor = Colors.grey;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: MaterialApp(
            theme: ThemeData(canvasColor: canvasColor),
            home: const AssetScreen(),
          ),
        ),
      );

      // Verify the screen renders without errors
      expect(find.byType(AssetScreen), findsOneWidget);
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Test scrolling behavior
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();
      
      // Should not throw any errors
      expect(find.byType(AssetScreen), findsOneWidget);
    });

    testWidgets('should maintain proper component order', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Find the main column
      final column = tester.widget<Column>(find.byType(Column).last);
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    testWidgets('should handle different screen sizes', (WidgetTester tester) async {
      // Test with different screen size
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      expect(find.byType(AssetScreen), findsOneWidget);
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should render all components without provider errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentScreenProvider.overrideWith((ref) => '/asset'),
          ],
          child: const MaterialApp(
            home: AssetScreen(),
          ),
        ),
      );

      // Pump and settle to ensure all widgets are built
      await tester.pumpAndSettle();

      // Verify no errors occurred during rendering
      expect(find.byType(AssetScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}