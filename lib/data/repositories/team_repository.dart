import '../datasources/team_remote_datasource.dart';

class TeamRepository {
  final TeamRemoteDataSource _remoteDataSource;

  const TeamRepository(this._remoteDataSource);
}
