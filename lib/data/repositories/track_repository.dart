import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../models/event/track_model.dart';
import '../services/track_remote_datasource.dart';

class TrackRepository {
  final TrackRemoteDataSource _remoteDataSource;

  const TrackRepository(this._remoteDataSource);

  Future<ApiResult<List<TrackModel>>> getTracks({String? eventId}) async {
    try {
      final tracks = await _remoteDataSource.getTracks(eventId: eventId);
      return Success(tracks);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<TrackModel?>> getTrackById(String trackId) async {
    try {
      final track = await _remoteDataSource.getTrackById(trackId);
      return Success(track);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
