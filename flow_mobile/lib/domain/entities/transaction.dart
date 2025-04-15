import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 4)
class Transaction {
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
    required this.name,
    required this.amount,
    required this.bankAccount,
    required this.category,
    required this.date,
    required this.method,
    required this.note,
  });
}
