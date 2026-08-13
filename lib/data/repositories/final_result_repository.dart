import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/network/paginated_data.dart';
import '../services/final_result_remote_datasource.dart';
import '../models/score/final_result_model.dart';

class FinalResultRepository {
  final FinalResultRemoteDataSource _dataSource;
  FinalResultRepository(this._dataSource);

  Future<ApiResult<PaginatedData<FinalResultModel>>> getRoundResults(
    String roundId, {
    int pageNumber = 1,
    int pageSize = 50,
  }) async {
    try {
      final result = await _dataSource.getRoundResults(
        roundId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
