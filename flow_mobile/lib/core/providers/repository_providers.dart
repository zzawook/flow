import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/domain/repositories/repositories.dart';
import 'package:flow_mobile/data/repositories/repositories.dart';
import 'package:flow_mobile/core/providers/datasource_providers.dart';

/// Provider for UserRepository
final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final localDataSource = await ref.read(userLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  
  return UserRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for TransactionRepository
final transactionRepositoryProvider = FutureProvider<TransactionRepository>((ref) async {
  final localDataSource = await ref.read(transactionLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(transactionRemoteDataSourceProvider);
  
  return TransactionRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for AccountRepository
final accountRepositoryProvider = FutureProvider<AccountRepository>((ref) async {
  final localDataSource = await ref.read(accountLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(accountRemoteDataSourceProvider);
  
  return AccountRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for SpendingRepository
final spendingRepositoryProvider = FutureProvider<SpendingRepository>((ref) async {
  final localDataSource = await ref.read(spendingLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(spendingRemoteDataSourceProvider);
  
  return SpendingRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for NotificationRepository
final notificationRepositoryProvider = FutureProvider<NotificationRepository>((ref) async {
  final localDataSource = await ref.read(notificationLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(notificationRemoteDataSourceProvider);
  
  return NotificationRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.read(authLocalDataSourceProvider);
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  
  return AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for SettingsRepository
final settingsRepositoryProvider = FutureProvider<SettingsRepository>((ref) async {
  final localDataSource = await ref.read(settingsLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(settingsRemoteDataSourceProvider);
  
  return SettingsRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

/// Provider for BankRepository
/// TODO: Create BankRepositoryImpl based on existing bank manager logic
// final bankRepositoryProvider = Provider<BankRepository>((ref) {
//   return BankRepositoryImpl(
//     localDataSource: ref.read(accountLocalDataSourceProvider),
//     remoteDataSource: ref.read(accountRemoteDataSourceProvider),
//   );
// });

/// Provider for TransferRepository
/// TODO: Create TransferRepositoryImpl based on existing transfer manager logic
// final transferRepositoryProvider = Provider<TransferRepository>((ref) {
//   return TransferRepositoryImpl(
//     localDataSource: ref.read(transactionLocalDataSourceProvider),
//     remoteDataSource: ref.read(transactionRemoteDataSourceProvider),
//   );
// });