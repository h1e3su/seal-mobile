import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/paginated_data.dart';
import '../models/score/final_result_model.dart';

class FinalResultRemoteDataSource {
  final DioClient _dioClient;

  const FinalResultRemoteDataSource(this._dioClient);

  Future<PaginatedData<FinalResultModel>> getRoundResults(
    String roundId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    final response = await _dioClient.dio.get(
      '${ApiEndpoints.finalResults}/round/$roundId',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return PaginatedData<FinalResultModel>.fromJson(
      response.data,
      (json) => FinalResultModel.fromJson(json),
    );
  }

  Future<List<FinalResultModel>> getTeamResults(String teamId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.finalResults}/team/$teamId');
    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => FinalResultModel.fromJson(json))
          .toList();
    }
    if (response.data is Map<String, dynamic>) {
      final list = response.data['data'] as List? ?? response.data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => FinalResultModel.fromJson(json))
          .toList();
    }
    return [];
  }
}
