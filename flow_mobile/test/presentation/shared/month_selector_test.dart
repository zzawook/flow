import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/month_selector.dart';

void main() {
  group('MonthSelector Widget Tests', () {
    testWidgets('should render current month correctly', (WidgetTester tester) async {
      final currentDate = DateTime(2024, 3, 15); // March 2024
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) => selectedDate = date,
            ),
          ),
        ),
      );

      // Verify month display (Mar for March)
      expect(find.text('Mar'), findsOneWidget);
      expect(find.byType(MonthSelector), findsOneWidget);
    });

    testWidgets('should show year when not current year', (WidgetTester tester) async {
      final pastDate = DateTime(2023, 6, 15); // June 2023
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: pastDate,
              displayMonthYearSetter: (date) => selectedDate = date,
            ),
          ),
        ),
      );

      // Verify month and year display (Jun 23')
      expect(find.text('Jun 23\''), findsOneWidget);
    });

    testWidgets('should call setter when previous month button is tapped', (WidgetTester tester) async {
      final currentDate = DateTime(2024, 3, 15); // March 2024
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) => selectedDate = date,
            ),
          ),
        ),
      );

      // Tap the previous month button (left arrow)
      await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
      await tester.pump();

      // Verify the setter was called with February 2024
      expect(selectedDate, equals(DateTime(2024, 2)));
    });

    testWidgets('should call setter when next month button is tapped for past months', (WidgetTester tester) async {
      final pastDate = DateTime(2024, 1, 15); // January 2024 (assuming current is later)
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: pastDate,
              displayMonthYearSetter: (date) => selectedDate = date,
            ),
          ),
        ),
      );

      // Tap the next month button (right arrow)
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
      await tester.pump();

      // Verify the setter was called with February 2024
      expect(selectedDate, equals(DateTime(2024, 2)));
    });

    testWidgets('should not call setter when next month button is tapped for current month', (WidgetTester tester) async {
      final currentDate = DateTime.now();
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) => selectedDate = date,
            ),
          ),
        ),
      );

      // Tap the next month button (right arrow)
      await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
      await tester.pump();

      // Verify the setter was not called (should remain null)
      expect(selectedDate, isNull);
    });

    testWidgets('should have correct layout structure', (WidgetTester tester) async {
      final currentDate = DateTime(2024, 3, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) {},
            ),
          ),
        ),
      );

      // Verify Row layout
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.center));

      // Verify both arrow icons are present
      expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);

      // Verify SizedBox for month text
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(90));
    });

    testWidgets('should have correct icon sizes', (WidgetTester tester) async {
      final currentDate = DateTime(2024, 3, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) {},
            ),
          ),
        ),
      );

      final leftIcon = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_left));
      final rightIcon = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_right));

      expect(leftIcon.size, equals(35));
      expect(rightIcon.size, equals(35));
    });

    testWidgets('should show different opacity for disabled next button', (WidgetTester tester) async {
      final currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              onSurface: Colors.black,
            ),
          ),
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) {},
            ),
          ),
        ),
      );

      final rightIcon = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_right));
      
      // The right arrow should have reduced opacity when disabled (current month)
      // This is indicated by the withAlpha(80) vs withAlpha(240) in the code
      expect(rightIcon.color?.alpha, equals(80));
    });

    testWidgets('should show full opacity for enabled next button', (WidgetTester tester) async {
      final pastDate = DateTime(2024, 1, 15); // Past month

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              onSurface: Colors.black,
            ),
          ),
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: pastDate,
              displayMonthYearSetter: (date) {},
            ),
          ),
        ),
      );

      final rightIcon = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_right));
      
      // The right arrow should have full opacity when enabled (past month)
      expect(rightIcon.color?.alpha, equals(240));
    });

    testWidgets('should handle year transitions correctly', (WidgetTester tester) async {
      final januaryDate = DateTime(2024, 1, 15); // January 2024
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: januaryDate,
              displayMonthYearSetter: (date) => selectedDate = date,
            ),
          ),
        ),
      );

      // Tap the previous month button to go to December 2023
      await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
      await tester.pump();

      // Verify the setter was called with December 2023
      expect(selectedDate, equals(DateTime(2023, 12)));
    });

    testWidgets('should center month text', (WidgetTester tester) async {
      final currentDate = DateTime(2024, 3, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) {},
            ),
          ),
        ),
      );

      final center = tester.widget<Center>(find.byType(Center));
      expect(center, isNotNull);
    });

    testWidgets('should have proper margins for arrow buttons', (WidgetTester tester) async {
      final currentDate = DateTime(2024, 3, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MonthSelector(
              displayMonthYear: currentDate,
              displayMonthYearSetter: (date) {},
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Find containers with margins
      final leftContainer = containers.firstWhere(
        (container) => container.margin == const EdgeInsets.only(right: 8),
      );
      final rightContainer = containers.firstWhere(
        (container) => container.margin == const EdgeInsets.only(left: 8),
      );

      expect(leftContainer, isNotNull);
      expect(rightContainer, isNotNull);
    });
  });
}