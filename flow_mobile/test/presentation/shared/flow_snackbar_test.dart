import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_snackbar.dart';

void main() {
  group('FlowSnackbar Widget Tests', () {
    testWidgets('should create SnackBar with correct content', (WidgetTester tester) async {
      const testContent = Text('Test message');
      const testDuration = 3;

      const snackbar = FlowSnackbar(
        content: testContent,
        duration: testDuration,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      // Verify SnackBar is created
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('should use correct duration', (WidgetTester tester) async {
      const testDuration = 5;

      const snackbar = FlowSnackbar(
        content: Text('Duration test'),
        duration: testDuration,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.duration, equals(const Duration(seconds: testDuration)));
    });

    testWidgets('should have floating behavior', (WidgetTester tester) async {
      const snackbar = FlowSnackbar(
        content: Text('Floating test'),
        duration: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.behavior, equals(SnackBarBehavior.floating));
    });

    testWidgets('should have correct margins', (WidgetTester tester) async {
      const snackbar = FlowSnackbar(
        content: Text('Margin test'),
        duration: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.margin, equals(const EdgeInsets.only(bottom: 48, left: 24, right: 24)));
    });

    testWidgets('should have correct padding', (WidgetTester tester) async {
      const snackbar = FlowSnackbar(
        content: Text('Padding test'),
        duration: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.padding, equals(const EdgeInsets.only(bottom: 16, top: 16, left: 24, right: 24)));
    });

    testWidgets('should use theme primary color', (WidgetTester tester) async {
      const primaryColor = Colors.blue;

      const snackbar = FlowSnackbar(
        content: Text('Color test'),
        duration: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: primaryColor),
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.backgroundColor, equals(primaryColor));
    });

    testWidgets('should have correct elevation', (WidgetTester tester) async {
      const snackbar = FlowSnackbar(
        content: Text('Elevation test'),
        duration: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.elevation, equals(10));
    });

    testWidgets('should have rounded rectangle shape', (WidgetTester tester) async {
      const snackbar = FlowSnackbar(
        content: Text('Shape test'),
        duration: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBarWidget.shape, isA<RoundedRectangleBorder>());
      
      final shape = snackBarWidget.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, equals(BorderRadius.circular(8)));
    });

    testWidgets('should handle complex content widgets', (WidgetTester tester) async {
      final complexContent = Row(
        children: const [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 8),
          Text('Success message'),
        ],
      );

      final snackbar = FlowSnackbar(
        content: complexContent,
        duration: 3,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => snackbar.build(context),
            ),
          ),
        ),
      );

      // Verify complex content is rendered
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Success message'), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('should handle different duration values', (WidgetTester tester) async {
      const durations = [1, 2, 5, 10];

      for (final duration in durations) {
        final snackbar = FlowSnackbar(
          content: Text('Duration $duration'),
          duration: duration,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => snackbar.build(context),
              ),
            ),
          ),
        );

        final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBarWidget.duration, equals(Duration(seconds: duration)));
      }
    });

    testWidgets('should work with different theme configurations', (WidgetTester tester) async {
      final themes = [
        ThemeData.light().copyWith(primaryColor: Colors.red),
        ThemeData.dark().copyWith(primaryColor: Colors.green),
        ThemeData().copyWith(primaryColor: Colors.purple),
      ];

      for (final theme in themes) {
        const snackbar = FlowSnackbar(
          content: Text('Theme test'),
          duration: 2,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Builder(
                builder: (context) => snackbar.build(context),
              ),
            ),
          ),
        );

        final snackBarWidget = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBarWidget.backgroundColor, equals(theme.primaryColor));
      }
    });
  });
}