// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paynow_recipient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayNowRecipientAdapter extends TypeAdapter<PayNowRecipient> {
  @override
  final int typeId = 7;

  @override
  PayNowRecipient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayNowRecipient(
      name: fields[0] as String,
      phoneNumber: fields[1] as String,
      idNumber: fields[2] as String,
      bank: fields[3] as Bank,
      transferCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PayNowRecipient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.idNumber)
      ..writeByte(3)
      ..write(obj.bank)
      ..writeByte(4)
      ..write(obj.transferCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayNowRecipientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
