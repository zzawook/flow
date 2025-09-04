import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction {
  @HiveField(7)
  final int id;

  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final BankAccount bankAccount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String method;

  @HiveField(6)
  final String note;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.bankAccount,
    required this.category,
    required this.date,
    required this.method,
    required this.note,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      amount.hashCode ^
      bankAccount.hashCode ^
      category.hashCode ^
      date.hashCode ^
      method.hashCode ^
      note.hashCode;

  @override
  String toString() {
    return 'Transaction{name: $name, amount: $amount, date: $date}';
  } 
}
