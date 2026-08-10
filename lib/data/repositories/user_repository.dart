import '../datasources/user_remote_datasource.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepository(this._remoteDataSource);
}
