import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../models/team/team_model.dart';
import '../services/team_remote_datasource.dart';

class TeamRepository {
  final TeamRemoteDataSource _remoteDataSource;

  const TeamRepository(this._remoteDataSource);

  Future<ApiResult<List<TeamModel>>> getTeams({String? trackId, String? eventId}) async {
    try {
      final teams = await _remoteDataSource.getTeams(trackId: trackId, eventId: eventId);
      return Success(teams);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<TeamModel?>> getTeamById(String id) async {
    try {
      final team = await _remoteDataSource.getTeamById(id);
      return Success(team);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<TeamModel?>> getMyTeam({String? eventId}) async {
    try {
      final team = await _remoteDataSource.getMyTeam(eventId: eventId);
      return Success(team);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<TeamModel>> createTeam({
    required String name,
    required String eventId,
    String? description,
    String? avatarUrl,
  }) async {
    try {
      final team = await _remoteDataSource.createTeam(
        name: name,
        eventId: eventId,
        description: description,
        avatarUrl: avatarUrl,
      );
      return Success(team);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> inviteMember(String teamId, String invitedUserIdOrEmail) async {
    try {
      await _remoteDataSource.inviteMember(teamId, invitedUserIdOrEmail);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> respondInvitation(String invitationId, bool isAccepted) async {
    try {
      await _remoteDataSource.respondInvitation(invitationId, isAccepted);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> removeMember(String teamId, String userId) async {
    try {
      await _remoteDataSource.removeMember(teamId, userId);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> leaveTeam(String teamId) async {
    try {
      await _remoteDataSource.leaveTeam(teamId);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> transferLeadership(String teamId, String newLeaderUserId) async {
    try {
      await _remoteDataSource.transferLeadership(teamId, newLeaderUserId);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> confirmRegistration(String teamId) async {
    try {
      await _remoteDataSource.confirmRegistration(teamId);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
