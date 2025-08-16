import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

part 'transfer_state_model.freezed.dart';

@freezed
class TransferStateModel with _$TransferStateModel {
  const factory TransferStateModel({
    required BankAccount fromAccount,
    required TransferReceivable receiving,
    @Default(0) int amount,
    @Default('') String remarks,
    @Default('PAYNOW') String network,
  }) = _TransferStateModel;

  factory TransferStateModel.initial() => TransferStateModel(
    fromAccount: BankAccount.initial(),
    receiving: BankAccount.initial(),
  );
}