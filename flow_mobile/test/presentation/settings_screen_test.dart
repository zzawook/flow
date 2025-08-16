import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/setting_screen/setting_screen.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

void main() {
  group('Settings Screen Tests', () {
    testWidgets('Settings screen should build without errors', (WidgetTester tester) async {
      // Create test providers
      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((ref) => const User(
            id: 'test-id',
            nickname: 'Test User',
            email: 'test@example.com',
          )),
          themeProvider.overrideWith((ref) => 'light'),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: SettingScreen(),
          ),
        ),
      );

      // Verify the screen builds
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Hi Test User,'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Bank Account'), findsOneWidget);
      expect(find.text('Notification'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
    });
  });
}