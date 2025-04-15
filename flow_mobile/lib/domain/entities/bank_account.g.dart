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
      accountNumber: fields[0] as String,
      accountHolder: fields[1] as String,
      balance: fields[2] as double,
      accountName: fields[3] as String,
      bank: fields[4] as Bank,
      transferCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BankAccount obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.accountNumber)
      ..writeByte(1)
      ..write(obj.accountHolder)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.accountName)
      ..writeByte(4)
      ..write(obj.bank)
      ..writeByte(5)
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
