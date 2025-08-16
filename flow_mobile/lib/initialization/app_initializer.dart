import 'package:flow_mobile/initialization/test_data_bootstrap.dart';
import 'package:flow_mobile/utils/env.dart';

class AppInitializer {
  static Future<void> initializeApplication() async {
    // Initialize Hive for local storage
    if (Env.isTestMode) {
      final bootstrapped = await TestDataBootstrap.bootstrapHiveWithTestData();
      if (!bootstrapped) {
        throw Exception('Failed to bootstrap Hive with test data');
      }
    }
    
    // Note: With Riverpod architecture, services and managers are now
    // initialized through providers when needed, eliminating the need
    // for manual service registration and state initialization
  }
}
