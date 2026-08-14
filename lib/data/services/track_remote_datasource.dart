import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/event/track_model.dart';

class TrackRemoteDataSource {
  final DioClient _dioClient;

  const TrackRemoteDataSource(this._dioClient);

  Future<List<TrackModel>> getTracks({String? eventId}) async {
    final queryParams = <String, dynamic>{};
    if (eventId != null) queryParams['eventId'] = eventId;

    final response = await _dioClient.dio.get(
      eventId != null ? ApiEndpoints.tracksByEvent : ApiEndpoints.tracks,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => TrackModel.fromJson(json))
          .toList();
    }
    if (response.data is Map<String, dynamic>) {
      final list = response.data['data'] as List? ?? response.data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => TrackModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<TrackModel?> getTrackById(String trackId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.tracks}/$trackId');
    if (response.data != null) {
      final data = response.data is Map<String, dynamic> && response.data['data'] != null
          ? response.data['data']
          : response.data;
      if (data is Map<String, dynamic>) {
        return TrackModel.fromJson(data);
      }
    }
    return null;
  }
}
