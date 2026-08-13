import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/event/track_model.dart';

class TrackRemoteDataSource {
  final DioClient _dioClient;

  const TrackRemoteDataSource(this._dioClient);

  Future<TrackModel?> getTrackById(String trackId) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.tracks}/$trackId');
    if (response.data != null && response.data is Map<String, dynamic>) {
      return TrackModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }
}
