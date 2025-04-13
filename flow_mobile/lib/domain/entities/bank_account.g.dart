// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankAccountAdapter extends TypeAdapter<BankAccount> {
  @override
  final int typeId = 2;

  @override
  BankAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankAccount(
      id: fields[0] as String,
      accountNumber: fields[1] as String,
      accountHolder: fields[2] as String,
      balance: fields[3] as double,
      accountName: fields[4] as String,
      bank: fields[5] as Bank,
      transferCount: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BankAccount obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.accountNumber)
      ..writeByte(2)
      ..write(obj.accountHolder)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.accountName)
      ..writeByte(5)
      ..write(obj.bank)
      ..writeByte(6)
      ..write(obj.transferCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
