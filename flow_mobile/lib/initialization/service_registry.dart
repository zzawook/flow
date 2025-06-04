import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:flow_mobile/service/local_source/local_secure_storage.dart';
import 'package:flow_mobile/service/api_service.dart';
import 'package:flow_mobile/service/auth_service.dart';
import 'package:flow_mobile/service/connection_service.dart';
import 'package:flow_mobile/service/local_database_service.dart';
import 'package:flow_mobile/service/local_secure_storage_service.dart';
import 'package:flow_mobile/service/notification_service.dart';
import 'package:flow_mobile/service/sync_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> initServices() async {
  await SecureHive.initHive(SecureStorage());
  
  getIt.registerSingleton<ConnectionService>(ConnectionService());
  getIt.registerSingleton<LocalSecureStorageService>(
    LocalSecureStorageService(localSecureStorage: SecureStorage()),
  );
  getIt.registerSingleton<LocalDatabaseService>(
    LocalDatabaseService(
      localSecureStorageService: getIt<LocalSecureStorageService>(),
    ),
  );
  getIt.registerSingleton<AuthService>(
    AuthService(localSecureStorageService: getIt<LocalSecureStorageService>()),
  );
  getIt.registerSingleton<ApiService>(
    ApiService(
      connectionService: getIt<ConnectionService>(),
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerSingleton<SyncService>(
    SyncService(apiService: getIt<ApiService>()),
  );
  getIt.registerSingleton<NotificationService>(NotificationService());
}
