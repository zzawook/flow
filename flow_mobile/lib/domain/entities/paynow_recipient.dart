import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/bank.dart';

part 'paynow_recipient.freezed.dart';
part 'paynow_recipient.g.dart';

@freezed
class PayNowRecipient with _$PayNowRecipient {
  const factory PayNowRecipient({
    required String name,
    required String phoneNumber,
    required String idNumber,
    @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
    required Bank bank,
    required int transferCount,
  }) = _PayNowRecipient;

  factory PayNowRecipient.fromJson(Map<String, dynamic> json) => _$PayNowRecipientFromJson(json);

  factory PayNowRecipient.initial() => PayNowRecipient(
    name: '',
    phoneNumber: '',
    idNumber: '',
    bank: Bank.initial(),
    transferCount: 0
  );
}

Bank _bankFromJson(Map<String, dynamic> json) => Bank.fromJson(json);
Map<String, dynamic> _bankToJson(Bank bank) => bank.toJson();

extension PayNowRecipientExtension on PayNowRecipient {
  String get identifier => phoneNumber;

  bool get isAccount => false;

  bool get isPayNow => true;
}