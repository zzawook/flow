import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';

void main() {
  group('FlowSeparatorBox Widget Tests', () {
    testWidgets('should render with default dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(),
          ),
        ),
      );

      // Verify the widget is rendered
      expect(find.byType(FlowSeparatorBox), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);

      // Verify default dimensions
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(1));
      expect(sizedBox.width, equals(1));
    });

    testWidgets('should use custom height when provided', (WidgetTester tester) async {
      const customHeight = 20.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(height: customHeight),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(customHeight));
      expect(sizedBox.width, equals(1)); // Default width
    });

    testWidgets('should use custom width when provided', (WidgetTester tester) async {
      const customWidth = 50.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(width: customWidth),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(1)); // Default height
      expect(sizedBox.width, equals(customWidth));
    });

    testWidgets('should use both custom height and width when provided', (WidgetTester tester) async {
      const customHeight = 30.0;
      const customWidth = 40.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(
              height: customHeight,
              width: customWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(customHeight));
      expect(sizedBox.width, equals(customWidth));
    });

    testWidgets('should work as vertical spacer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                Text('Top'),
                FlowSeparatorBox(height: 16),
                Text('Bottom'),
              ],
            ),
          ),
        ),
      );

      // Verify both text widgets are present
      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);
      expect(find.byType(FlowSeparatorBox), findsOneWidget);

      // Verify the separator has correct height
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(16));
    });

    testWidgets('should work as horizontal spacer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Text('Left'),
                FlowSeparatorBox(width: 24),
                Text('Right'),
              ],
            ),
          ),
        ),
      );

      // Verify both text widgets are present
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
      expect(find.byType(FlowSeparatorBox), findsOneWidget);

      // Verify the separator has correct width
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(24));
    });

    testWidgets('should handle zero dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(height: 0, width: 0),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(0));
      expect(sizedBox.width, equals(0));
    });

    testWidgets('should handle large dimensions', (WidgetTester tester) async {
      const largeHeight = 1000.0;
      const largeWidth = 2000.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(
              height: largeHeight,
              width: largeWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(largeHeight));
      expect(sizedBox.width, equals(largeWidth));
    });

    testWidgets('should handle fractional dimensions', (WidgetTester tester) async {
      const fractionalHeight = 12.5;
      const fractionalWidth = 8.75;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlowSeparatorBox(
              height: fractionalHeight,
              width: fractionalWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, equals(fractionalHeight));
      expect(sizedBox.width, equals(fractionalWidth));
    });

    testWidgets('should work in complex layouts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Header'),
                const FlowSeparatorBox(height: 20),
                Row(
                  children: const [
                    Text('Left'),
                    FlowSeparatorBox(width: 10),
                    Text('Center'),
                    FlowSeparatorBox(width: 10),
                    Text('Right'),
                  ],
                ),
                const FlowSeparatorBox(height: 30),
                const Text('Footer'),
              ],
            ),
          ),
        ),
      );

      // Verify all components are present
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
      
      // Verify multiple separators
      expect(find.byType(FlowSeparatorBox), findsNWidgets(4));
    });

    testWidgets('should be const constructible', (WidgetTester tester) async {
      // This test verifies that the widget can be created as const
      const separator = FlowSeparatorBox(height: 10, width: 20);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: separator,
          ),
        ),
      );

      expect(find.byType(FlowSeparatorBox), findsOneWidget);
    });
  });
}