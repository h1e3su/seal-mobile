import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/submission/submit_result_model.dart';

class SubmitResultRemoteDataSource {
  final DioClient _dioClient;

  const SubmitResultRemoteDataSource(this._dioClient);

  Future<List<SubmitResultModel>> getSubmissions({String? teamId, String? trackId}) async {
    final queryParams = <String, dynamic>{};
    if (teamId != null) queryParams['teamId'] = teamId;
    if (trackId != null) queryParams['trackId'] = trackId;

    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.submitResults,
        queryParameters: queryParams,
      );
      return _parseSubmissionList(response.data);
    } catch (_) {
      // Fallback to my-submissions if available
      final response = await _dioClient.dio.get(ApiEndpoints.mySubmissions);
      return _parseSubmissionList(response.data);
    }
  }

  Future<SubmitResultModel?> getSubmissionById(String id) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.submitResults}/$id');
    if (response.data != null) {
      final data = response.data is Map<String, dynamic> && response.data['data'] != null
          ? response.data['data']
          : response.data;
      if (data is Map<String, dynamic>) {
        return SubmitResultModel.fromJson(data);
      }
    }
    return null;
  }

  Future<SubmitResultModel> submitResult({
    required String teamId,
    required String trackId,
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.submitResults,
      data: {
        'teamId': teamId,
        'trackId': trackId,
        'title': title,
        'description': ?description,
        'submissionUrl': submissionUrl,
        'attachmentUrl': ?attachmentUrl,
      },
    );

    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;
    if (data is Map<String, dynamic>) {
      return SubmitResultModel.fromJson(data);
    }
    return SubmitResultModel(
      id: '',
      teamId: teamId,
      trackId: trackId,
      title: title,
      description: description,
      submissionUrl: submissionUrl,
      attachmentUrl: attachmentUrl,
    );
  }

  Future<SubmitResultModel> updateSubmission(
    String id, {
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    final response = await _dioClient.dio.put(
      '${ApiEndpoints.submitResults}/$id',
      data: {
        'title': title,
        'description': ?description,
        'submissionUrl': submissionUrl,
        'attachmentUrl': ?attachmentUrl,
      },
    );

    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;
    if (data is Map<String, dynamic>) {
      return SubmitResultModel.fromJson(data);
    }
    return SubmitResultModel(
      id: id,
      teamId: '',
      trackId: '',
      title: title,
      submissionUrl: submissionUrl,
    );
  }

  Future<void> deleteSubmission(String id) async {
    await _dioClient.dio.delete('${ApiEndpoints.submitResults}/$id');
  }

  List<SubmitResultModel> _parseSubmissionList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => SubmitResultModel.fromJson(json))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final rawList = data['data'] as List? ?? data['items'] as List? ?? [];
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => SubmitResultModel.fromJson(json))
          .toList();
    }
    return [];
  }
}
