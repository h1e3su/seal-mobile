import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/score/score_breakdown_model.dart';
import '../models/score/template_model.dart';

class ScoreRemoteDataSource {
  final DioClient _dioClient;

  const ScoreRemoteDataSource(this._dioClient);

  Future<ScoreBreakdownModel> getTeamBreakdown(String teamId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.teamScoreBreakdown}/$teamId/breakdown');
    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;
    if (data is Map<String, dynamic>) {
      return ScoreBreakdownModel.fromJson(data);
    }
    throw Exception('Dữ liệu bảng điểm không hợp lệ');
  }

  Future<TemplateModel?> getTemplate(String templateId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.templates}/$templateId');
    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;
    if (data is Map<String, dynamic>) {
      return TemplateModel.fromJson(data);
    }
    return null;
  }

  Future<void> saveScore({
    required String eventRoleId,
    required String submitResultId,
    String? comment,
    required List<Map<String, dynamic>> details,
  }) async {
    await _dioClient.dio.post(
      ApiEndpoints.saveScore,
      data: {
        'eventRoleId': eventRoleId,
        'submitResultId': submitResultId,
        'comment': ?comment,
        'details': details,
      },
    );
  }
}
