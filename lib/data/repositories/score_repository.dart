import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../models/score/score_breakdown_model.dart';
import '../models/score/template_model.dart';
import '../services/score_remote_datasource.dart';

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

  Future<ApiResult<TemplateModel?>> getTemplate(String templateId) async {
    try {
      final result = await _dataSource.getTemplate(templateId);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> saveScore({
    required String eventRoleId,
    required String submitResultId,
    String? comment,
    required List<Map<String, dynamic>> details,
  }) async {
    try {
      await _dataSource.saveScore(
        eventRoleId: eventRoleId,
        submitResultId: submitResultId,
        comment: comment,
        details: details,
      );
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
