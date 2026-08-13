import '../services/track_remote_datasource.dart';
import '../models/event/track_model.dart';

class TrackRepository {
  final TrackRemoteDataSource _remoteDataSource;

  const TrackRepository(this._remoteDataSource);

  Future<TrackModel?> getTrackById(String trackId) async {
    try {
      return await _remoteDataSource.getTrackById(trackId);
    } catch (_) {
      return null;
    }
  }
}
