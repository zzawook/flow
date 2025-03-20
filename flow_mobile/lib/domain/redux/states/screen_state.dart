class ScreenState {
  final String screenName;
  final String previousScreenName;

  ScreenState({required this.screenName, this.previousScreenName = "/home"});

  ScreenState copyWith({required String screenName}) {
    return ScreenState(
      screenName: screenName,
      previousScreenName: this.screenName,
    );
  }

  static ScreenState initial() {
    return ScreenState(screenName: "/home", previousScreenName: "/home");
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
