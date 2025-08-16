import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank.freezed.dart';
part 'bank.g.dart';

@freezed
class Bank with _$Bank {
  const factory Bank({
    required String name,
    required String logoPath,
  }) = _Bank;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  factory Bank.initial() => const Bank(
    name: '', 
    logoPath: 'assets/bank_logos/DBS.png'
  );
}

extension BankExtension on Bank {
  bool isEqualTo(Bank other) {
    return name == other.name;
  }
}