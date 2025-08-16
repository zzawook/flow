import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    required int id,
    required String title,
    required String body,
    String? imageUrl,
    String? action,
    required DateTime createdAt,
    @Default(false) bool isChecked,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}