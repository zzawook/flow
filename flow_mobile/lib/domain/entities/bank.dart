import 'package:hive_flutter/hive_flutter.dart';

part 'bank.g.dart';

@HiveType(typeId: 3)
class Bank {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String logoPath;

  Bank({required this.name, required this.logoPath});

  factory Bank.initial() =>
      Bank(name: '', logoPath: 'assets/bank_logos/DBS.png');
}
