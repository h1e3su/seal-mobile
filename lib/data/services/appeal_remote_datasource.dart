import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/score/appeal_model.dart';

class AppealRemoteDataSource {
  final DioClient _dioClient;

  const AppealRemoteDataSource(this._dioClient);

  Future<List<AppealModel>> getMyAppeals([String? teamId]) async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.myTeamAppeals);
      return _parseAppealsList(response.data);
    } catch (_) {
      if (teamId != null && teamId.isNotEmpty) {
        final response = await _dioClient.dio.get('${ApiEndpoints.teamAppeals}/$teamId');
        return _parseAppealsList(response.data);
      }
      return [];
    }
  }

  Future<AppealModel> createAppeal({
    required String teamId,
    required String roundId,
    required String reason,
    String? evidenceUrl,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.appeals,
      data: {
        'teamId': teamId,
        'roundId': roundId,
        'reason': reason,
        'evidenceUrl': ?evidenceUrl,
      },
    );

    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;

    if (data is Map<String, dynamic>) {
      return AppealModel.fromJson(data);
    }
    return AppealModel(
      id: '',
      teamId: teamId,
      roundId: roundId,
      reason: reason,
      evidenceUrl: evidenceUrl,
    );
  }

  Future<void> respondAppeal(String id, {required String status, String? comment}) async {
    await _dioClient.dio.put(
      '${ApiEndpoints.appeals}/$id/respond',
      data: {
        'status': status,
        'responseComment': ?comment,
      },
    );
  }

  List<AppealModel> _parseAppealsList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => AppealModel.fromJson(json))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final rawList = data['data'] as List? ?? data['items'] as List? ?? [];
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => AppealModel.fromJson(json))
          .toList();
    }
    return [];
  }
}
