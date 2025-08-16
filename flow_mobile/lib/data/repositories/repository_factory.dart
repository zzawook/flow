import 'package:flow_mobile/data/repositories/repositories.dart';
import 'package:flow_mobile/data/datasources/datasource_factory.dart';
import 'package:flow_mobile/domain/repositories/repositories.dart';

/// Factory class for creating repository instances
/// Manages data source injection and repository creation
class RepositoryFactory {
  static RepositoryFactory? _instance;
  final DataSourceFactory _dataSourceFactory;
  
  // Singleton pattern
  static RepositoryFactory get instance {
    _instance ??= RepositoryFactory._(DataSourceFactory.instance);
    return _instance!;
  }
  
  RepositoryFactory._(this._dataSourceFactory);

  /// Create transaction repository with data sources
  Future<TransactionRepository> createTransactionRepository() async {
    final localDataSource = await _dataSourceFactory.createTransactionLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createTransactionRemoteDataSource();
    
    return TransactionRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  /// Create user repository with data sources
  Future<UserRepository> createUserRepository() async {
    final localDataSource = await _dataSourceFactory.createUserLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createUserRemoteDataSource();
    
    return UserRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  /// Create account repository with data sources
  Future<AccountRepository> createAccountRepository() async {
    final localDataSource = await _dataSourceFactory.createAccountLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createAccountRemoteDataSource();
    
    return AccountRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  /// Create notification repository with data sources
  Future<NotificationRepository> createNotificationRepository() async {
    final localDataSource = await _dataSourceFactory.createNotificationLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createNotificationRemoteDataSource();
    
    return NotificationRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  /// Create spending repository with data sources
  Future<SpendingRepository> createSpendingRepository() async {
    final localDataSource = await _dataSourceFactory.createSpendingLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createSpendingRemoteDataSource();
    
    return SpendingRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  /// Create settings repository with data sources
  Future<SettingsRepository> createSettingsRepository() async {
    final localDataSource = await _dataSourceFactory.createSettingsLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createSettingsRemoteDataSource();
    
    return SettingsRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  /// Create auth repository with data sources
  Future<AuthRepository> createAuthRepository() async {
    final localDataSource = _dataSourceFactory.createAuthLocalDataSource();
    final remoteDataSource = _dataSourceFactory.createAuthRemoteDataSource();
    
    return AuthRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }
}