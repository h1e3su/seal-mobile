import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../models/score/appeal_model.dart';
import '../services/appeal_remote_datasource.dart';

class AppealRepository {
  final AppealRemoteDataSource _remoteDataSource;

  const AppealRepository(this._remoteDataSource);

  Future<ApiResult<List<AppealModel>>> getMyAppeals([String? teamId]) async {
    try {
      final appeals = await _remoteDataSource.getMyAppeals(teamId);
      return Success(appeals);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<AppealModel>> createAppeal({
    required String teamId,
    required String roundId,
    required String reason,
    String? evidenceUrl,
  }) async {
    try {
      final appeal = await _remoteDataSource.createAppeal(
        teamId: teamId,
        roundId: roundId,
        reason: reason,
        evidenceUrl: evidenceUrl,
      );
      return Success(appeal);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> respondAppeal(String id, {required String status, String? comment}) async {
    try {
      await _remoteDataSource.respondAppeal(id, status: status, comment: comment);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
