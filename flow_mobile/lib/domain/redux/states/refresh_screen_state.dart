import 'package:flow_mobile/domain/entity/bank.dart';

class RefreshScreenState {
  List<Bank> banksToRefresh;
  List<Bank> banksOnLink;
  bool isLinking;
  String? linkStartTimestamp;
  Bank? linkingBank;

  Map<String, String> bankLoginMemo = {};

  RefreshScreenState({
    required this.banksToRefresh,
    this.banksOnLink = const [],
    this.isLinking = false,
    this.linkStartTimestamp,
    this.linkingBank,
    this.bankLoginMemo = const {},
  });

  RefreshScreenState.initial()
    : banksToRefresh = [],
      banksOnLink = const [],
      isLinking = false,
      linkingBank = null,
      linkStartTimestamp = null,
      bankLoginMemo = const {};

  RefreshScreenState copyWith({
    List<Bank>? banksToRefresh,
    List<Bank>? banksOnLink,
    bool? isLinking,
    Bank? linkingBank,
    String? linkStartTimestamp,
    Map<String, String>? bankLoginMemo,
  }) {
    return RefreshScreenState(
      banksToRefresh: banksToRefresh ?? this.banksToRefresh,
      banksOnLink: banksOnLink ?? this.banksOnLink,
      isLinking: isLinking ?? this.isLinking,
      linkingBank: linkingBank ?? this.linkingBank,
      linkStartTimestamp: linkStartTimestamp ?? this.linkStartTimestamp,
      bankLoginMemo: bankLoginMemo ?? this.bankLoginMemo,
    );
  }

  @override
  String toString() {
    return 'RefreshScreenState{banksToRefresh: $banksToRefresh, banksOnLink: $banksOnLink, isLinking: $isLinking, linkingBank: $linkingBank, linkStartTimestamp: $linkStartTimestamp, bankLoginMemo: $bankLoginMemo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RefreshScreenState &&
        other.banksToRefresh == banksToRefresh &&
        other.banksOnLink == banksOnLink &&
        other.isLinking == isLinking &&
        other.linkingBank == linkingBank &&
        other.linkStartTimestamp == linkStartTimestamp &&
        other.bankLoginMemo == bankLoginMemo;
  }

  @override
  int get hashCode =>
      banksToRefresh.hashCode ^
      banksOnLink.hashCode ^
      isLinking.hashCode ^
      (linkingBank?.hashCode ?? 0) ^
      (linkStartTimestamp?.hashCode ?? 0) ^
      bankLoginMemo.hashCode;
}
