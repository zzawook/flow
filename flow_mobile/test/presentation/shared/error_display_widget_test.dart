import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/shared/error_display_widget.dart';
import 'package:flow_mobile/core/errors/errors.dart';

void main() {
  group('ErrorDisplayWidget Tests', () {
    testWidgets('should render nothing when error is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ErrorDisplayWidget(error: null),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('Error'), findsNothing);
    });

    testWidgets('should display inline error correctly', (WidgetTester tester) async {
      const error = AppError.network('Network connection failed');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ErrorDisplayWidget(
                error: error,
                showAsInline: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Network connection failed'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show retry button for retryable errors', (WidgetTester tester) async {
      const error = AppError.network('Network connection failed');
      bool retryPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ErrorDisplayWidget(
                error: error,
                showAsInline: true,
                onRetry: () => retryPressed = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      
      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryPressed, isTrue);
    });

    testWidgets('should not show retry button for non-retryable errors', (WidgetTester tester) async {
      const error = AppError.validation('Invalid input');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ErrorDisplayWidget(
                error: error,
                showAsInline: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('should have correct styling for inline error', (WidgetTester tester) async {
      const error = AppError.storage('Storage error');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ErrorDisplayWidget(
                error: error,
                showAsInline: true,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, equals(Colors.red.shade50));
      expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
    });
  });

  group('LoadingIndicatorWidget Tests', () {
    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicatorWidget(isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show child when isLoading is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicatorWidget(
              isLoading: false,
              child: Text('Content loaded'),
            ),
          ),
        ),
      );

      expect(find.text('Content loaded'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show loading text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicatorWidget(
              isLoading: true,
              loadingText: 'Loading data...',
            ),
          ),
        ),
      );

      expect(find.text('Loading data...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not show loading text when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicatorWidget(isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });
  });

  group('StateDisplayWidget Tests', () {
    testWidgets('should show loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StateDisplayWidget<String>(
                state: const AsyncLoading(),
                builder: (data) => Text(data),
                loadingText: 'Loading...',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should show data state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StateDisplayWidget<String>(
                state: const AsyncData('Test data'),
                builder: (data) => Text(data),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test data'), findsOneWidget);
    });

    testWidgets('should show error state', (WidgetTester tester) async {
      const error = AppError.network('Network error');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StateDisplayWidget<String>(
                state: AsyncError(error, StackTrace.empty),
                builder: (data) => Text(data),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Network error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show empty widget for empty list', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StateDisplayWidget<List<String>>(
                state: const AsyncData([]),
                builder: (data) => Text('List: ${data.length}'),
                emptyWidget: const Text('No items'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('should show default empty message when no empty widget provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StateDisplayWidget<List<String>>(
                state: const AsyncData([]),
                builder: (data) => Text('List: ${data.length}'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is pressed', (WidgetTester tester) async {
      const error = AppError.network('Network error');
      bool retryPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StateDisplayWidget<String>(
                state: AsyncError(error, StackTrace.empty),
                builder: (data) => Text(data),
                onRetry: () => retryPressed = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryPressed, isTrue);
    });
  });
}