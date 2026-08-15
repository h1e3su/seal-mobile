import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/paginated_data.dart';
import '../models/score/final_result_model.dart';

import '../../core/utils/response_parser.dart';

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
    final rawList = ResponseParser.extractList(response.data);
    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => FinalResultModel.fromJson(json))
        .toList();
  }
}
