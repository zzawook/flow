import 'dart:ffi';

import 'package:hive_flutter/hive_flutter.dart';

part 'notification.g.dart';

@HiveType(typeId: 6)
class Notification {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String? action;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final bool isChecked;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.action,
    required this.createdAt,
    this.isChecked = false,
  });

  Notification copyWith({
    int? id,
    String? title,
    String? body,
    String? imageUrl,
    String? action,
    DateTime? createdAt,
    bool? isChecked,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
