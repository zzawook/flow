import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flow_mobile/domain/entities/notification.dart' as w;
import 'package:flutter_redux/flutter_redux.dart';

/// The notifications page now lists all notifications in a single column without grouping.
class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<w.Notification> notifications = [
    w.Notification(
      id: 1,
      title: 'New Message from Alice',
      body: 'Hey, check out my latest photo!',
      imageUrl: 'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    w.Notification(
      id: 2,
      title: 'Event Reminder',
      body: 'Don’t forget the meeting at 3 PM.',
      imageUrl: 'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    w.Notification(
      id: 3,
      title: 'Update Available',
      body: 'A new update is available for download.',
      imageUrl: 'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
      createdAt: DateTime.now().subtract(const Duration(days: 1, minutes: 20)),
    ),
    w.Notification(
      id: 4,
      title: 'Promotion Alert',
      body: 'Check out our latest promotion and save big!',
      imageUrl: 'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Optionally sort notifications by date descending (newest first).
    final sortedNotifications = List<w.Notification>.from(notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          // Top bar with title
          Padding(
            padding: const EdgeInsets.only(top: 72, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlowButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/icons/previous.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0x88000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.asset('assets/icons/setting.png', width: 22, height: 22),
              ],
            ),
          ),
          Expanded(
            // Displays a single list of notifications (no grouping).
            child: StoreConnector<FlowState, NotificationState>(
              converter: (store) => store.state.notificationState,
              builder: (context, notificationState) {
                final notifications = notificationState.getNotification();
                print(notificationState.notifications);
                final sortedNotifications = List<w.Notification>.from(
                  notifications,
                )..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedNotifications.length,
                  itemBuilder: (context, index) {
                    final w.Notification notification =
                        sortedNotifications[index];
                    return NotificationCard(notification: notification);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that renders an individual notification card.
class NotificationCard extends StatelessWidget {
  final w.Notification notification;
  const NotificationCard({super.key, required this.notification});

  /// Formats the [createdAt] time as HH:mm.
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
      padding: const EdgeInsets.only(left: 0, right: 12, top: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification image
          ClipOval(
            child: Image.network(
              notification.imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.white, size: 30),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Notification details (title, body, time)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0x88000000),
                      ),
                    ),
                    Text(
                      _formatTime(notification.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.body,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xBB000000),
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
