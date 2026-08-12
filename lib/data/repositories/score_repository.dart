import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../datasources/score_remote_datasource.dart';
import '../models/score/score_breakdown_model.dart';

class ScoreRepository {
  final ScoreRemoteDataSource _dataSource;
  ScoreRepository(this._dataSource);

  Future<ApiResult<ScoreBreakdownModel>> getTeamBreakdown(String teamId) async {
    try {
      final result = await _dataSource.getTeamBreakdown(teamId);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
