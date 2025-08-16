import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';

void main() {
  group('FlowSafeArea Widget Tests', () {
    testWidgets('should render child widget correctly', (WidgetTester tester) async {
      const childText = 'Test Child';

      await tester.pumpWidget(
        MaterialApp(
          home: FlowSafeArea(
            child: const Text(childText),
          ),
        ),
      );

      // Verify the child widget is rendered
      expect(find.text(childText), findsOneWidget);
      expect(find.byType(FlowSafeArea), findsOneWidget);
    });

    testWidgets('should use transparent background by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlowSafeArea(
            child: const Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, equals(Colors.transparent));
    });

    testWidgets('should use custom background color when provided', (WidgetTester tester) async {
      const customColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          home: FlowSafeArea(
            backgroundColor: customColor,
            child: const Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, equals(customColor));
    });

    testWidgets('should apply correct padding based on MediaQuery', (WidgetTester tester) async {
      // Set up a custom MediaQuery with specific padding
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(top: 44, left: 20, right: 20),
            ),
            child: FlowSafeArea(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(const EdgeInsets.only(top: 44, left: 20, right: 20)));
    });

    testWidgets('should use full screen dimensions', (WidgetTester tester) async {
      // Set up a custom MediaQuery with specific screen size
      const screenSize = Size(400, 800);
      
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: screenSize,
              padding: EdgeInsets.zero,
            ),
            child: FlowSafeArea(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.minHeight, equals(screenSize.height));
      expect(container.constraints?.minWidth, equals(screenSize.width));
    });

    testWidgets('should not apply bottom padding', (WidgetTester tester) async {
      // Set up MediaQuery with bottom padding to verify it's not applied
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(top: 44, left: 20, right: 20, bottom: 34),
            ),
            child: FlowSafeArea(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      // Should not include bottom padding
      expect(container.padding, equals(const EdgeInsets.only(top: 44, left: 20, right: 20)));
    });

    testWidgets('should handle zero padding correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.zero,
            ),
            child: FlowSafeArea(
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(EdgeInsets.zero));
    });

    testWidgets('should work with complex child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlowSafeArea(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                const Text('Header'),
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(title: Text('Item 1')),
                      ListTile(title: Text('Item 2')),
                    ],
                  ),
                ),
                const Text('Footer'),
              ],
            ),
          ),
        ),
      );

      // Verify complex child structure is rendered
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should maintain child widget properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlowSafeArea(
            child: Container(
              width: 200,
              height: 100,
              color: Colors.red,
              child: const Text('Styled Child'),
            ),
          ),
        ),
      );

      // Verify child container properties are maintained
      final childContainer = tester.widget<Container>(find.byType(Container).last);
      expect(childContainer.constraints?.minWidth, equals(200));
      expect(childContainer.constraints?.minHeight, equals(100));
      expect(childContainer.color, equals(Colors.red));
      expect(find.text('Styled Child'), findsOneWidget);
    });

    testWidgets('should handle different screen orientations', (WidgetTester tester) async {
      // Test portrait orientation
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800), // Portrait
              padding: EdgeInsets.only(top: 44),
            ),
            child: FlowSafeArea(
              child: const Text('Portrait'),
            ),
          ),
        ),
      );

      expect(find.text('Portrait'), findsOneWidget);

      // Test landscape orientation
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(800, 400), // Landscape
              padding: EdgeInsets.only(left: 44, right: 44),
            ),
            child: FlowSafeArea(
              child: const Text('Landscape'),
            ),
          ),
        ),
      );

      expect(find.text('Landscape'), findsOneWidget);
    });
  });
}