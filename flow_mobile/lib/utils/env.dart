class Env {
  static const bool isTestMode =
      String.fromEnvironment("environment", defaultValue: "test") == "test";
}
