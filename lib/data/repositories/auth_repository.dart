import '../datasources/auth_remote_datasource.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepository(this._remoteDataSource);
}
