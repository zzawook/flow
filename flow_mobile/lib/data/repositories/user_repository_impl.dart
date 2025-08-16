import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/repositories/user_repository.dart';
import 'package:flow_mobile/data/datasources/local/user_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/user_remote_datasource.dart';

/// Implementation of UserRepository using data sources
/// Maintains identical behavior to UserManagerImpl
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({
    required UserLocalDataSource localDataSource,
    required UserRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<User> getUser() {
    return _localDataSource.getUser();
  }

  @override
  Future<void> updateUser(User user) {
    return _localDataSource.updateUser(user);
  }

  @override
  Future<void> deleteUser() {
    return _localDataSource.deleteUser();
  }
}