import 'package:flow_mobile/domain/entity/bank.dart';

class RefreshScreenState {
  List<Bank> banksToRefresh;
  bool isLinking;
  String? linkStartTimestamp;
  Bank? linkingBank;

  RefreshScreenState({
    required this.banksToRefresh,
    this.isLinking = false,
    this.linkStartTimestamp,
    this.linkingBank,
  });

  RefreshScreenState.initial()
    : banksToRefresh = [],
      isLinking = false,
      linkingBank = null,
      linkStartTimestamp = null;

  RefreshScreenState copyWith({
    List<Bank>? banksToRefresh,
    bool? isLinking,
    Bank? linkingBank,
    String? linkStartTimestamp,
  }) {
    return RefreshScreenState(
      banksToRefresh: banksToRefresh ?? this.banksToRefresh,
      isLinking: isLinking ?? this.isLinking,
      linkingBank: linkingBank ?? this.linkingBank,
      linkStartTimestamp: linkStartTimestamp ?? this.linkStartTimestamp,
    );
  }

  @override
  String toString() {
    return 'RefreshScreenState{banksToRefresh: $banksToRefresh, isLinking: $isLinking, linkingBank: $linkingBank, linkStartTimestamp: $linkStartTimestamp}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RefreshScreenState &&
        other.banksToRefresh == banksToRefresh &&
        other.isLinking == isLinking &&
        other.linkingBank == linkingBank &&
        other.linkStartTimestamp == linkStartTimestamp;
  }

  @override
  int get hashCode =>
      banksToRefresh.hashCode ^
      isLinking.hashCode ^
      (linkingBank?.hashCode ?? 0) ^
      (linkStartTimestamp?.hashCode ?? 0);
}
