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
          .map((json) => TeamModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<TeamModel?> getTeamById(String id) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.teams}/$id');
    if (response.data != null && response.data is Map<String, dynamic>) {
      return TeamModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }
}
