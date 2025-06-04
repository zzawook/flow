import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/initialization/flow_state_initializer.dart';
import 'package:flow_mobile/initialization/test_data_bootstrap.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/service/api_service.dart';
import 'package:flow_mobile/utils/env.dart';
import 'package:get_it/get_it.dart';

class AppInitializer {
  static Future<FlowState> initializeApplication() async {
    await initServices(); // Services are in charge of connecting external entities with application
    await initManagers(); // Managers are in charge of managing the entities and its relevant business logics

    if (Env.isTestMode) {
      final bootstrapped = await TestDataBootstrap.bootstrapHiveWithTestData();
      if (!bootstrapped) {
        throw Exception('Failed to bootstrap Hive with test data');
      }
    }

    FlowState flowState = await FlowStateInitializer.buildInitialState();
    await initRequests(flowState);
    return flowState;
  }

  static Future<void> initRequests(FlowState flowState) async {
    GetIt getIt = GetIt.instance;
    AuthManager authManager = getIt<AuthManager>();

    authManager.attemptLogin();
  }
}
