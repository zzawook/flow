import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';

void main() {
  group('FlowCTAButton Widget Tests', () {
    testWidgets('should render with default properties', (WidgetTester tester) async {
      const testText = 'CTA Button';
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: testText,
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Verify the button text is rendered
      expect(find.text(testText), findsOneWidget);
      expect(find.byType(FlowCTAButton), findsOneWidget);

      // Verify default styling
      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.constraints?.minHeight, equals(60));

      final text = tester.widget<Text>(find.text(testText));
      expect(text.style?.fontSize, equals(20));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
      expect(text.style?.color, equals(const Color(0xFFFFFFFF)));
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Press me',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(FlowCTAButton));
      await tester.pump();
      
      // Wait for the timer to complete
      await tester.pump(const Duration(milliseconds: 100));

      // Verify onPressed was called
      expect(wasPressed, isTrue);
    });

    testWidgets('should use custom color when provided', (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Custom Color',
              onPressed: () {},
              color: customColor,
            ),
          ),
        ),
      );

      // Find the container with decoration
      final container = tester.widget<Container>(find.byType(Container).last);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(customColor));
    });

    testWidgets('should use theme primary color when no color provided', (WidgetTester tester) async {
      const themePrimaryColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: themePrimaryColor),
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Theme Color',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the container with decoration
      final container = tester.widget<Container>(find.byType(Container).last);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(themePrimaryColor));
    });

    testWidgets('should use custom text color when provided', (WidgetTester tester) async {
      const customTextColor = Colors.black;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Custom Text Color',
              onPressed: () {},
              textColor: customTextColor,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Custom Text Color'));
      expect(text.style?.color, equals(customTextColor));
    });

    testWidgets('should use custom border radius when provided', (WidgetTester tester) async {
      const customBorderRadius = 24.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Custom Radius',
              onPressed: () {},
              borderRadius: customBorderRadius,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, equals(customBorderRadius));
    });

    testWidgets('should use custom font weight when provided', (WidgetTester tester) async {
      const customFontWeight = FontWeight.w300;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Custom Weight',
              onPressed: () {},
              fontWeight: customFontWeight,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Custom Weight'));
      expect(text.style?.fontWeight, equals(customFontWeight));
    });

    testWidgets('should have correct container height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Height Test',
              onPressed: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.constraints?.minHeight, equals(60));
    });

    testWidgets('should center align text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Centered Text',
              onPressed: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.alignment, equals(Alignment.center));
    });

    testWidgets('should use Inter font family', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowCTAButton(
              text: 'Font Test',
              onPressed: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Font Test'));
      expect(text.style?.fontFamily, equals('Inter'));
    });
  });
}