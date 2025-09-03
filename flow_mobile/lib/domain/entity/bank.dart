import 'package:hive_flutter/hive_flutter.dart';

part 'bank.g.dart';

@HiveType(typeId: 3)
class Bank {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int bankId;

  Bank({required this.name, required this.bankId});

  factory Bank.initial() =>
      Bank(name: '', bankId: 0);

  bool isEqualTo(Bank other) {
    return name == other.name && bankId == other.bankId;
  }

  String get assetPath => 'assets/bank_logos/${name.toUpperCase()}.png';
}
