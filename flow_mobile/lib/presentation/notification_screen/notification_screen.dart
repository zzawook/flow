import 'package:flow_mobile/domain/entities/notification.dart' as entities;
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The notifications page now lists all notifications in a single column without grouping.
class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedNotifications = ref.watch(sortedNotificationsProvider);
    
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          // Top bar with title
          FlowTopBar(
            title: Text(
              "Notifications",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // Displays a single list of notifications (no grouping).
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedNotifications.length,
              itemBuilder: (context, index) {
                final notification = sortedNotifications[index];
                return NotificationCard(notification: notification);
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
  final entities.Notification notification;
  const NotificationCard({super.key, required this.notification});

  /// Formats the [createdAt] time as HH:mm.
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
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
                      style: Theme.of(context).textTheme.bodyMedium,
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(180),
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
