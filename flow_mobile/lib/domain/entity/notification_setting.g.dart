// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingAdapter extends TypeAdapter<NotificationSetting> {
  @override
  final int typeId = 6;

  @override
  NotificationSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSetting(
      masterEnabled: fields[0] as bool,
      insightNotificationEnabled: fields[1] as bool,
      periodicNotificationEnabled: fields[2] as bool,
      periodicNotificationAutoEnabled: fields[3] as bool,
      periodicNotificationCron: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSetting obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.masterEnabled)
      ..writeByte(1)
      ..write(obj.insightNotificationEnabled)
      ..writeByte(2)
      ..write(obj.periodicNotificationEnabled)
      ..writeByte(3)
      ..write(obj.periodicNotificationAutoEnabled)
      ..writeByte(4)
      ..write(obj.periodicNotificationCron);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
