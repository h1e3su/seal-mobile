import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/score/score_breakdown_model.dart';

class ScoreRemoteDataSource {
  final DioClient _dioClient;

  const ScoreRemoteDataSource(this._dioClient);

  Future<ScoreBreakdownModel> getTeamBreakdown(String teamId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.teamScoreBreakdown}/$teamId/breakdown');
    if (response.data != null && response.data is Map<String, dynamic>) {
      return ScoreBreakdownModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Dữ liệu bảng điểm không hợp lệ');
  }
}
