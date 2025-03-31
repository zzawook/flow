import 'package:hive_flutter/hive_flutter.dart';

part 'setting.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final String theme;

  @HiveField(2)
  final double fontScale;

  @HiveField(3)
  final bool notification;

  Settings({
    required this.language,
    required this.theme,
    required this.fontScale,
    required this.notification,
  });

  Settings copyWith({
    String? language,
    String? theme,
    double? fontScale,
    bool? notification,
  }) {
    return Settings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontScale: fontScale ?? this.fontScale,
      notification: notification ?? this.notification,
    );
  }

  factory Settings.initial() {
    return Settings(
      language: 'en',
      theme: 'light',
      fontScale: 1.0,
      notification: true,
    );
  }
}
