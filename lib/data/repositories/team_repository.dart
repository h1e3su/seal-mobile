import '../datasources/team_remote_datasource.dart';
import '../models/team/team_model.dart';

class TeamRepository {
  final TeamRemoteDataSource _remoteDataSource;

  const TeamRepository(this._remoteDataSource);

  Future<List<TeamModel>> getTeams({String? trackId, String? eventId}) async {
    try {
      return await _remoteDataSource.getTeams(trackId: trackId, eventId: eventId);
    } catch (_) {
      return [];
    }
  }

  Future<TeamModel?> getTeamById(String id) async {
    try {
      return await _remoteDataSource.getTeamById(id);
    } catch (_) {
      return null;
    }
  }
}
