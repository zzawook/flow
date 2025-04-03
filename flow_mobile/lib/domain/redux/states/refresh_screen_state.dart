import 'package:flow_mobile/domain/entities/bank.dart';

class RefreshScreenState {
  List<Bank> banksToRefresh;

  RefreshScreenState({
    required this.banksToRefresh,
  });

  RefreshScreenState.initial()
      : banksToRefresh = [];

  RefreshScreenState copyWith({
    List<Bank>? banksToRefresh,
  }) {
    return RefreshScreenState(
      banksToRefresh: banksToRefresh ?? this.banksToRefresh,
    );
  }

  @override
  String toString() {
    return 'RefreshScreenState{banksToRefresh: $banksToRefresh}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RefreshScreenState &&
        other.banksToRefresh == banksToRefresh;
  }
  
  @override
  int get hashCode => banksToRefresh.hashCode;
}
