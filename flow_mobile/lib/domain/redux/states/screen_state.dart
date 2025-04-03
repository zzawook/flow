import 'package:flow_mobile/domain/redux/states/refresh_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';

class ScreenState {
  final String screenName;
  final SpendingScreenState spendingScreenState;
  final RefreshScreenState refreshScreenState;
  final bool isRefreshing;

  ScreenState({
    required this.screenName,
    required this.spendingScreenState,
    required this.isRefreshing,
    required this.refreshScreenState,
  });

  ScreenState copyWith({
    required String screenName,
    required SpendingScreenState spendingScreenState,
    required bool isRefreshing,
    required RefreshScreenState refreshScreenState,
  }) {
    return ScreenState(
      screenName: screenName,
      spendingScreenState: spendingScreenState,
      isRefreshing: isRefreshing,
      refreshScreenState: refreshScreenState,
    );
  }

  static ScreenState initial() {
    return ScreenState(
      screenName: "/home",
      spendingScreenState: SpendingScreenState.initial(),
      isRefreshing: false,
      refreshScreenState: RefreshScreenState.initial(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenState &&
          runtimeType == other.runtimeType &&
          screenName == other.screenName &&
          spendingScreenState == other.spendingScreenState;

  @override
  int get hashCode => screenName.hashCode;

  @override
  String toString() {
    return 'ScreenState{screenName: $screenName}';
  }
}
