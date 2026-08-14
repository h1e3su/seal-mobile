import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../models/submission/submit_result_model.dart';
import '../services/submit_result_remote_datasource.dart';

class SubmissionRepository {
  final SubmitResultRemoteDataSource _remoteDataSource;

  const SubmissionRepository(this._remoteDataSource);

  Future<ApiResult<List<SubmitResultModel>>> getSubmissions({String? teamId, String? trackId}) async {
    try {
      final submissions = await _remoteDataSource.getSubmissions(teamId: teamId, trackId: trackId);
      return Success(submissions);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<SubmitResultModel?>> getSubmissionById(String id) async {
    try {
      final submission = await _remoteDataSource.getSubmissionById(id);
      return Success(submission);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<SubmitResultModel>> submitResult({
    required String teamId,
    required String trackId,
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    try {
      final submission = await _remoteDataSource.submitResult(
        teamId: teamId,
        trackId: trackId,
        title: title,
        description: description,
        submissionUrl: submissionUrl,
        attachmentUrl: attachmentUrl,
      );
      return Success(submission);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<SubmitResultModel>> updateSubmission(
    String id, {
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    try {
      final submission = await _remoteDataSource.updateSubmission(
        id,
        title: title,
        description: description,
        submissionUrl: submissionUrl,
        attachmentUrl: attachmentUrl,
      );
      return Success(submission);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> deleteSubmission(String id) async {
    try {
      await _remoteDataSource.deleteSubmission(id);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
