import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';

class ScreenState {
  final String screenName;
  final SpendingScreenState spendingScreenState;

  ScreenState({required this.screenName, required this.spendingScreenState});

  ScreenState copyWith({required String screenName, required SpendingScreenState spendingScreenState}) {
    return ScreenState(
      screenName: screenName,
      spendingScreenState: spendingScreenState,
    );
  }

  static ScreenState initial() {
    return ScreenState(screenName: "/home", spendingScreenState: SpendingScreenState.initial());
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
