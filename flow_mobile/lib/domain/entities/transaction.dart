import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 4)
class Transaction {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String method;

  @HiveField(5)
  final String note;

  Transaction({
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.method,
    required this.note,
  });
}
