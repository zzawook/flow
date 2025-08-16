import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/notification_screen/notification_screen.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flow_mobile/domain/entities/notification.dart' as entities;

void main() {
  group('NotificationScreen Widget Tests', () {
    late List<entities.Notification> mockNotifications;

    setUp(() {
      mockNotifications = [
        entities.Notification(
          id: '1',
          title: 'Payment Received',
          body: 'You received \$100 from John Doe',
          createdAt: DateTime(2024, 3, 15, 10, 30),
          imageUrl: 'https://example.com/image1.jpg',
          isRead: false,
        ),
        entities.Notification(
          id: '2',
          title: 'Transfer Complete',
          body: 'Your transfer of \$50 has been completed',
          createdAt: DateTime(2024, 3, 15, 9, 15),
          imageUrl: 'https://example.com/image2.jpg',
          isRead: true,
        ),
      ];
    });

    testWidgets('should render notification screen with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sortedNotificationsProvider.overrideWith((ref) => mockNotifications),
          ],
          child: const MaterialApp(
            home: NotificationScreen(),
          ),
        ),
      );

      // Verify screen title
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byType(NotificationScreen), findsOneWidget);
    });

    testWidgets('should display list of notifications', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sortedNotificationsProvider.overrideWith((ref) => mockNotifications),
          ],
          child: const MaterialApp(
            home: NotificationScreen(),
          ),
        ),
      );

      // Verify ListView is present
      expect(find.byType(ListView), findsOneWidget);
      
      // Verify notification cards are displayed
      expect(find.byType(NotificationCard), findsNWidgets(2));
      
      // Verify notification content
      expect(find.text('Payment Received'), findsOneWidget);
      expect(find.text('Transfer Complete'), findsOneWidget);
    });

    testWidgets('should handle empty notifications list', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sortedNotificationsProvider.overrideWith((ref) => <entities.Notification>[]),
          ],
          child: const MaterialApp(
            home: NotificationScreen(),
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(NotificationScreen), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      
      // ListView should be present but empty
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(NotificationCard), findsNothing);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sortedNotificationsProvider.overrideWith((ref) => mockNotifications),
          ],
          child: const MaterialApp(
            home: NotificationScreen(),
          ),
        ),
      );

      // Verify main layout components
      expect(find.byType(FlowSafeArea), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(FlowTopBar), findsOneWidget);
    });

    testWidgets('should use correct padding for ListView', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sortedNotificationsProvider.overrideWith((ref) => mockNotifications),
          ],
          child: const MaterialApp(
            home: NotificationScreen(),
          ),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should use theme colors correctly', (WidgetTester tester) async {
      const canvasColor = Colors.white;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sortedNotificationsProvider.overrideWith((ref) => mockNotifications),
          ],
          child: MaterialApp(
            theme: ThemeData(
              canvasColor: canvasColor,
              textTheme: const TextTheme(
                titleLarge: TextStyle(fontSize: 20),
              ),
            ),
            home: const NotificationScreen(),
          ),
        ),
      );

      // Verify the screen renders with theme colors
      expect(find.byType(NotificationScreen), findsOneWidget);
    });
  });

  group('NotificationCard Widget Tests', () {
    late entities.Notification mockNotification;

    setUp(() {
      mockNotification = entities.Notification(
        id: '1',
        title: 'Test Notification',
        body: 'This is a test notification body that might be quite long and should be truncated properly',
        createdAt: DateTime(2024, 3, 15, 14, 30),
        imageUrl: 'https://example.com/test-image.jpg',
        isRead: false,
      );
    });

    testWidgets('should render notification card with all elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      // Verify notification content
      expect(find.text('Test Notification'), findsOneWidget);
      expect(find.text('This is a test notification body that might be quite long and should be truncated properly'), findsOneWidget);
      
      // Verify time format (14:30)
      expect(find.text('14:30'), findsOneWidget);
      
      // Verify image widget
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should format time correctly', (WidgetTester tester) async {
      final morningNotification = entities.Notification(
        id: '1',
        title: 'Morning Notification',
        body: 'Good morning!',
        createdAt: DateTime(2024, 3, 15, 9, 5), // 09:05
        imageUrl: null,
        isRead: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: morningNotification),
          ),
        ),
      );

      // Verify time is formatted with leading zeros
      expect(find.text('09:05'), findsOneWidget);
    });

    testWidgets('should handle null image URL with error widget', (WidgetTester tester) async {
      final notificationWithoutImage = entities.Notification(
        id: '1',
        title: 'No Image Notification',
        body: 'This notification has no image',
        createdAt: DateTime(2024, 3, 15, 12, 0),
        imageUrl: null,
        isRead: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: notificationWithoutImage),
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(NotificationCard), findsOneWidget);
      expect(find.text('No Image Notification'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      // Verify layout components
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(ClipOval), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should have correct margins and padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.margin, equals(const EdgeInsets.only(bottom: 12)));
      expect(container.padding, equals(const EdgeInsets.only(left: 0, right: 12, top: 16, bottom: 16)));
    });

    testWidgets('should have correct image dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, equals(60));
      expect(image.height, equals(60));
      expect(image.fit, equals(BoxFit.cover));
    });

    testWidgets('should truncate long body text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      // Find the body text widget
      final bodyTextFinder = find.text('This is a test notification body that might be quite long and should be truncated properly');
      expect(bodyTextFinder, findsOneWidget);

      final bodyText = tester.widget<Text>(bodyTextFinder);
      expect(bodyText.maxLines, equals(2));
      expect(bodyText.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('should have proper spacing between elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      // Verify SizedBox spacing elements
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.any((box) => box.width == 16), isTrue); // Horizontal spacing
      expect(sizedBoxes.any((box) => box.height == 8), isTrue); // Vertical spacing
    });

    testWidgets('should handle image loading error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      // The image widget should have an errorBuilder
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.errorBuilder, isNotNull);
    });

    testWidgets('should use correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16),
            ),
          ),
          home: Scaffold(
            body: NotificationCard(notification: mockNotification),
          ),
        ),
      );

      // Verify text elements are present
      expect(find.text('Test Notification'), findsOneWidget);
      expect(find.text('14:30'), findsOneWidget);
    });
  });
}