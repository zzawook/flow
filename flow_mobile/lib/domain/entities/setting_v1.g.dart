// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_v1.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsV1Adapter extends TypeAdapter<SettingsV1> {
  @override
  final int typeId = 7;

  @override
  SettingsV1 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsV1(
      language: fields[0] as String,
      theme: fields[1] as String,
      fontScale: fields[2] as double,
      notification: fields[3] as NotificationSetting,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsV1 obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.fontScale)
      ..writeByte(3)
      ..write(obj.notification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsV1Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
