import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';

void main() {
  group('FlowButton Widget Tests', () {
    testWidgets('should render child widget correctly', (WidgetTester tester) async {
      const testText = 'Test Button';
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowButton(
              onPressed: () => wasPressed = true,
              child: const Text(testText),
            ),
          ),
        ),
      );

      // Verify the child widget is rendered
      expect(find.text(testText), findsOneWidget);
      expect(find.byType(FlowButton), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowButton(
              onPressed: () => wasPressed = true,
              child: const Text('Tap me'),
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(FlowButton));
      await tester.pump();
      
      // Wait for the timer to complete
      await tester.pump(const Duration(milliseconds: 100));

      // Verify onPressed was called
      expect(wasPressed, isTrue);
    });

    testWidgets('should show pressed animation when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowButton(
              onPressed: () {},
              child: const Text('Animate me'),
            ),
          ),
        ),
      );

      // Find the AnimatedScale widget
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, equals(1.0));

      // Start tap down
      await tester.startGesture(tester.getCenter(find.byType(FlowButton)));
      await tester.pump();

      // Verify scale changed during press
      final animatedScalePressed = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScalePressed.scale, equals(0.99));
    });

    testWidgets('should handle tap cancel correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowButton(
              onPressed: () {},
              child: const Text('Cancel me'),
            ),
          ),
        ),
      );

      // Start gesture and then cancel
      final gesture = await tester.startGesture(tester.getCenter(find.byType(FlowButton)));
      await tester.pump();
      
      // Cancel the gesture
      await gesture.cancel();
      await tester.pump();

      // Verify scale returns to normal
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, equals(1.0));
    });

    testWidgets('should apply color filter when pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowButton(
              onPressed: () {},
              child: Container(
                width: 100,
                height: 50,
                color: Colors.blue,
                child: const Text('Color Filter Test'),
              ),
            ),
          ),
        ),
      );

      // Verify ColorFiltered widget exists
      expect(find.byType(ColorFiltered), findsOneWidget);

      // Start tap to trigger pressed state
      await tester.startGesture(tester.getCenter(find.byType(FlowButton)));
      await tester.pump();

      // Verify ColorFiltered widget still exists (color filter should be applied)
      expect(find.byType(ColorFiltered), findsOneWidget);
    });

    testWidgets('should handle multiple rapid taps', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowButton(
              onPressed: () => tapCount++,
              child: const Text('Multi tap'),
            ),
          ),
        ),
      );

      // Perform multiple rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(FlowButton));
        await tester.pump(const Duration(milliseconds: 10));
      }

      // Wait for all animations and timers to complete
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // Verify all taps were registered
      expect(tapCount, equals(5));
    });
  });
}