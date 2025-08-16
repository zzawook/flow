import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

part 'bank_account_state_model.freezed.dart';

@freezed
class BankAccountStateModel with _$BankAccountStateModel {
  const factory BankAccountStateModel({
    @Default(false) bool isLoading,
    @Default([]) List<BankAccount> bankAccounts,
    @Default('') String error,
  }) = _BankAccountStateModel;

  factory BankAccountStateModel.initial() => const BankAccountStateModel();
}