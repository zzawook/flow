class Env {
  static const bool isTestMode =
      String.fromEnvironment("environment", defaultValue: "test") == "test";
  static const String apiHost =
      String.fromEnvironment("apiBaseUrl", defaultValue: "10.0.2.2");
  static const int apiPort =
      int.fromEnvironment("apiPort", defaultValue: 9090);
  static const bool useSecureConnection =
      String.fromEnvironment("useSecureConnection", defaultValue: "false") == "true";
}
