import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/team/team_model.dart';

class TeamRemoteDataSource {
  final DioClient _dioClient;

  const TeamRemoteDataSource(this._dioClient);

  Future<List<TeamModel>> getTeams({String? trackId, String? eventId}) async {
    final queryParams = <String, dynamic>{};
    if (trackId != null) queryParams['trackId'] = trackId;
    if (eventId != null) queryParams['eventId'] = eventId;

    final response = await _dioClient.dio.get(
      ApiEndpoints.teams,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => TeamModel.fromJson(json))
          .toList();
    }
    if (response.data is Map<String, dynamic>) {
      final list = response.data['data'] as List? ?? response.data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => TeamModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<TeamModel?> getTeamById(String id) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.teams}/$id');
    if (response.data != null) {
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'] ?? response.data;
        if (data is Map<String, dynamic>) {
          return TeamModel.fromJson(data);
        }
      }
    }
    return null;
  }

  Future<TeamModel?> getMyTeam({String? eventId}) async {
    final queryParams = <String, dynamic>{};
    if (eventId != null) queryParams['eventId'] = eventId;

    final response = await _dioClient.dio.get(
      ApiEndpoints.myTeam,
      queryParameters: queryParams,
    );

    if (response.data != null) {
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'] ?? response.data;
        if (data is Map<String, dynamic>) {
          return TeamModel.fromJson(data);
        }
      }
    }
    return null;
  }

  Future<TeamModel> createTeam({
    required String name,
    required String eventId,
    String? description,
    String? avatarUrl,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.teams,
      data: {
        'name': name,
        'eventId': eventId,
        'description': ?description,
        'avatarUrl': ?avatarUrl,
      },
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data['data'] ?? response.data;
      if (data is Map<String, dynamic>) {
        return TeamModel.fromJson(data);
      }
    }
    return TeamModel(id: '', name: name, eventId: eventId);
  }

  Future<void> inviteMember(String teamId, String invitedUserIdOrEmail) async {
    final isEmail = invitedUserIdOrEmail.contains('@');
    final data = isEmail
        ? {'email': invitedUserIdOrEmail}
        : {'invitedUserId': invitedUserIdOrEmail};

    try {
      await _dioClient.dio.post(
        '${ApiEndpoints.teams}/$teamId/invitations',
        data: data,
      );
    } catch (_) {
      // Fallback endpoint if BE uses /members/invite
      await _dioClient.dio.post(
        '${ApiEndpoints.teams}/$teamId/members/invite',
        data: data,
      );
    }
  }

  Future<void> respondInvitation(String invitationId, bool isAccepted) async {
    await _dioClient.dio.post(
      '${ApiEndpoints.teamInvitations}/$invitationId/respond',
      queryParameters: {'isAccepted': isAccepted},
    );
  }

  Future<void> removeMember(String teamId, String userId) async {
    await _dioClient.dio.delete(
      '${ApiEndpoints.teams}/$teamId/members/$userId',
    );
  }

  Future<void> leaveTeam(String teamId) async {
    await _dioClient.dio.post(
      '${ApiEndpoints.teams}/$teamId/leave',
    );
  }

  Future<void> transferLeadership(String teamId, String newLeaderUserId) async {
    await _dioClient.dio.post(
      '${ApiEndpoints.teams}/$teamId/transfer-leader',
      data: {'newLeaderUserId': newLeaderUserId},
    );
  }

  Future<void> confirmRegistration(String teamId) async {
    await _dioClient.dio.post(
      '${ApiEndpoints.teams}/$teamId/confirm-registration',
    );
  }
}
