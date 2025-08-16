import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/presentation/shared/flow_text_edit_bottom_sheet.dart';

void main() {
  group('FlowTextEditBottomSheet Widget Tests', () {
    testWidgets('should render with all required elements', (WidgetTester tester) async {
      String? savedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: 'John Doe',
              hintText: 'Enter your name',
              saveButtonText: 'Save',
              onSave: (value) => savedValue = value,
            ),
          ),
        ),
      );

      // Verify all elements are present
      expect(find.text('Edit Name'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should initialize TextField with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: 'Initial Value',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals('Initial Value'));
    });

    testWidgets('should show hint text in TextField', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter your name here',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, equals('Enter your name here'));
    });

    testWidgets('should call onSave with trimmed text when save button is pressed', (WidgetTester tester) async {
      String? savedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) => savedValue = value,
            ),
          ),
        ),
      );

      // Enter text with spaces
      await tester.enterText(find.byType(TextField), '  Test Value  ');
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Verify trimmed value is saved
      expect(savedValue, equals('Test Value'));
    });

    testWidgets('should have autofocus on TextField', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('should use theme primary color for cursor and borders', (WidgetTester tester) async {
      const primaryColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: primaryColor),
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.cursorColor, equals(primaryColor));

      final decoration = textField.decoration as InputDecoration;
      final enabledBorder = decoration.enabledBorder as UnderlineInputBorder;
      final focusedBorder = decoration.focusedBorder as UnderlineInputBorder;

      expect(enabledBorder.borderSide.color, equals(primaryColor));
      expect(focusedBorder.borderSide.color, equals(primaryColor));
      expect(focusedBorder.borderSide.width, equals(2));
    });

    testWidgets('should use theme primary color for button background', (WidgetTester tester) async {
      const primaryColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: primaryColor),
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style!;
      final backgroundColor = buttonStyle.backgroundColor?.resolve({});
      expect(backgroundColor, equals(primaryColor));
    });

    testWidgets('should have correct padding that responds to keyboard', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(
                viewInsets: EdgeInsets.only(bottom: 300), // Simulate keyboard
              ),
              child: FlowTextEditBottomSheet(
                title: 'Edit Name',
                initialValue: '',
                hintText: 'Enter text',
                saveButtonText: 'Save',
                onSave: (value) {},
              ),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 324, // 300 (keyboard) + 24 (base padding)
      )));
    });

    testWidgets('should have correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      // Verify layout components
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisSize, equals(MainAxisSize.min));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    testWidgets('should have full-width button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).last);
      expect(sizedBox.width, equals(double.infinity));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style!;
      final minimumSize = buttonStyle.minimumSize?.resolve({});
      expect(minimumSize, equals(const Size.fromHeight(48)));
    });

    testWidgets('should have rounded button shape', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style!;
      final shape = buttonStyle.shape?.resolve({}) as RoundedRectangleBorder;
      expect(shape.borderRadius, equals(BorderRadius.circular(8)));
    });

    testWidgets('should handle empty initial value', (WidgetTester tester) async {
      String? savedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) => savedValue = value,
            ),
          ),
        ),
      );

      // Save without entering text
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(savedValue, equals(''));
    });

    testWidgets('should handle text editing', (WidgetTester tester) async {
      String? savedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: 'Original',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) => savedValue = value,
            ),
          ),
        ),
      );

      // Clear and enter new text
      await tester.enterText(find.byType(TextField), 'New Value');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(savedValue, equals('New Value'));
    });

    testWidgets('should use correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              titleMedium: TextStyle(fontSize: 18),
              bodyLarge: TextStyle(fontSize: 16),
            ),
          ),
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      // Verify text elements are present
      expect(find.text('Edit Name'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('should handle hint text color with alpha', (WidgetTester tester) async {
      const primaryColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: primaryColor),
          home: Scaffold(
            body: FlowTextEditBottomSheet(
              title: 'Edit Name',
              initialValue: '',
              hintText: 'Enter text',
              saveButtonText: 'Save',
              onSave: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      final hintStyle = decoration.hintStyle;
      
      expect(hintStyle?.color, equals(primaryColor.withAlpha(153)));
    });
  });
}