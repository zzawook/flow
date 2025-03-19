class SettingsState {
  final String currency;
  final bool darkMode;

  SettingsState({required this.currency, required this.darkMode});

  factory SettingsState.initial() => SettingsState(currency: "SGD", darkMode: false);
}

