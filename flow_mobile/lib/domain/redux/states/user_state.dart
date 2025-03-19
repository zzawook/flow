class UserState {
  final String username;
  final String email;

  UserState({required this.username, required this.email});

  factory UserState.initial() => UserState(username: "Guest", email: "");
}

// Action
class UpdateUserAction {
  final String username;
  final String email;

  UpdateUserAction(this.username, this.email);
}

// Reducer
