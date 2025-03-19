class ScreenState {
  final String screenName;

  ScreenState({required this.screenName});

  ScreenState copyWith({required String screenName}) {
    return ScreenState(screenName: screenName);
  }

  static ScreenState initial() {
    return ScreenState(screenName: "Home");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenState &&
          runtimeType == other.runtimeType &&
          screenName == other.screenName;

  @override
  int get hashCode => screenName.hashCode;

  @override
  String toString() {
    return 'ScreenState{screenName: $screenName}';
  }
}
