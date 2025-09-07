import 'package:hive_flutter/hive_flutter.dart';

part 'bank.g.dart';

@HiveType(typeId: 1)
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

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is Bank &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          bankId == other.bankId;

  @override
  int get hashCode => name.hashCode ^ bankId.hashCode;
}
