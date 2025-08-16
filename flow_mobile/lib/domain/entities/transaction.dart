import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String name,
    required double amount,
    @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
    required BankAccount bankAccount,
    required String category,
    required DateTime date,
    required String method,
    required String note,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

BankAccount _bankAccountFromJson(Map<String, dynamic> json) => BankAccount.fromJson(json);
Map<String, dynamic> _bankAccountToJson(BankAccount bankAccount) => bankAccount.toJson();