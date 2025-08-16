import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/shared/flow_horizontal_divider.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

void main() {
  group('FlowHorizontalDivider Widget Tests', () {
    testWidgets('should render divider with light theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      // Verify the divider is rendered
      expect(find.byType(FlowHorizontalDivider), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should use light theme colors correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      
      // Verify light theme color (grey.shade400)
      expect(border.top.color, equals(Colors.grey.shade400));
    });

    testWidgets('should use dark theme colors correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'dark'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      
      // Verify dark theme color (0x88EDEDED)
      expect(border.top.color, equals(const Color(0x88EDEDED)));
    });

    testWidgets('should have correct height', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minHeight, equals(1));
    });

    testWidgets('should have correct border width', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      
      expect(border.top.width, equals(1.0));
    });

    testWidgets('should work in column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: const [
                  Text('Above'),
                  FlowHorizontalDivider(),
                  Text('Below'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify all components are present
      expect(find.text('Above'), findsOneWidget);
      expect(find.text('Below'), findsOneWidget);
      expect(find.byType(FlowHorizontalDivider), findsOneWidget);
    });

    testWidgets('should work with padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: const FlowHorizontalDivider(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FlowHorizontalDivider), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith((ref) => 'light'),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      // Verify light theme initially
      var containerWidget = tester.widget<Container>(find.byType(Container));
      var decoration = containerWidget.decoration as BoxDecoration;
      var border = decoration.border as Border;
      expect(border.top.color, equals(Colors.grey.shade400));

      // Change to dark theme
      container.updateOverrides([
        themeProvider.overrideWith((ref) => 'dark'),
      ]);
      await tester.pump();

      // Verify dark theme color
      containerWidget = tester.widget<Container>(find.byType(Container));
      decoration = containerWidget.decoration as BoxDecoration;
      border = decoration.border as Border;
      expect(border.top.color, equals(const Color(0x88EDEDED)));

      container.dispose();
    });

    testWidgets('should handle unknown theme gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'unknown'),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: FlowHorizontalDivider(),
            ),
          ),
        ),
      );

      // Should render without errors and default to dark theme color
      expect(find.byType(FlowHorizontalDivider), findsOneWidget);
      
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      
      // Should use dark theme color for unknown theme
      expect(border.top.color, equals(const Color(0x88EDEDED)));
    });

    testWidgets('should work in list views', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: const [
                  ListTile(title: Text('Item 1')),
                  FlowHorizontalDivider(),
                  ListTile(title: Text('Item 2')),
                  FlowHorizontalDivider(),
                  ListTile(title: Text('Item 3')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.byType(FlowHorizontalDivider), findsNWidgets(2));
    });

    testWidgets('should maintain consistent appearance across multiple instances', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeProvider.overrideWith((ref) => 'light'),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: const [
                  FlowHorizontalDivider(),
                  SizedBox(height: 20),
                  FlowHorizontalDivider(),
                  SizedBox(height: 20),
                  FlowHorizontalDivider(),
                ],
              ),
            ),
          ),
        ),
      );

      final dividers = tester.widgetList<Container>(find.byType(Container));
      
      // All dividers should have the same properties
      for (final divider in dividers) {
        expect(divider.constraints?.minHeight, equals(1));
        final decoration = divider.decoration as BoxDecoration;
        final border = decoration.border as Border;
        expect(border.top.color, equals(Colors.grey.shade400));
        expect(border.top.width, equals(1.0));
      }
    });
  });
}