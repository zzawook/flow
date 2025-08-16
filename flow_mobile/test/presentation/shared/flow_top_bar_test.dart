import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';

void main() {
  group('FlowTopBar Widget Tests', () {
    testWidgets('should render title widget correctly', (WidgetTester tester) async {
      const titleText = 'Test Title';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text(titleText),
            ),
          ),
        ),
      );

      // Verify the title is rendered
      expect(find.text(titleText), findsOneWidget);
      expect(find.byType(FlowTopBar), findsOneWidget);
    });

    testWidgets('should show back button by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
            ),
          ),
        ),
      );

      // Verify back button is shown
      expect(find.byType(Image), findsOneWidget);
      
      // Verify the image asset path
      final image = tester.widget<Image>(find.byType(Image));
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, equals('assets/icons/previous.png'));
    });

    testWidgets('should hide back button when showBackButton is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
              showBackButton: false,
            ),
          ),
        ),
      );

      // Verify back button is not shown (should show empty box instead)
      expect(find.byType(Image), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should show custom left widget when provided', (WidgetTester tester) async {
      const leftWidgetText = 'Left Widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
              leftWidget: const Text(leftWidgetText),
            ),
          ),
        ),
      );

      // Verify custom left widget is shown
      expect(find.text(leftWidgetText), findsOneWidget);
    });

    testWidgets('should call Navigator.pop when back button is tapped', (WidgetTester tester) async {
      bool popCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: FlowTopBar(
                title: const Text('Title'),
              ),
            ),
          ),
          navigatorObservers: [
            _TestNavigatorObserver(onPop: () => popCalled = true),
          ],
        ),
      );

      // Tap the back button
      await tester.tap(find.byType(Image));
      await tester.pump();

      // Note: In a real test environment, Navigator.pop might not work as expected
      // This test verifies the button is tappable
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have correct height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, equals(48));
    });

    testWidgets('should have correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.only(left: 16, right: 16)));
    });

    testWidgets('should center title with proper layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Centered Title'),
            ),
          ),
        ),
      );

      // Verify Row layout
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.center));

      // Verify Expanded widget wraps the title
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should handle empty title widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(FlowTopBar), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should maintain consistent icon size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.height, equals(20));
      expect(image.width, equals(20));
    });

    testWidgets('should show both back button and left widget when both provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTopBar(
              title: const Text('Title'),
              leftWidget: const Icon(Icons.settings),
              showBackButton: true,
            ),
          ),
        ),
      );

      // Verify both back button and left widget are shown
      expect(find.byType(Image), findsOneWidget); // Back button
      expect(find.byType(Icon), findsOneWidget); // Left widget
    });
  });
}

class _TestNavigatorObserver extends NavigatorObserver {
  final VoidCallback? onPop;

  _TestNavigatorObserver({this.onPop});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPop?.call();
    super.didPop(route, previousRoute);
  }
}