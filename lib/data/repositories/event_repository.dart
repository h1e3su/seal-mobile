import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/network/paginated_data.dart';
import '../models/event/event_model.dart';
import '../models/event/round_model.dart';
import '../models/event/track_model.dart';
import '../services/event_remote_datasource.dart';

class EventRepository {
  final EventRemoteDataSource _remoteDataSource;

  const EventRepository(this._remoteDataSource);

  Future<ApiResult<PaginatedData<EventModel>>> getEvents({int pageNumber = 1, int pageSize = 20}) async {
    try {
      final result = await _remoteDataSource.getEvents(pageNumber: pageNumber, pageSize: pageSize);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<PaginatedData<EventModel>>> getUpcomingEvents({int pageNumber = 1, int pageSize = 20}) async {
    try {
      final result = await _remoteDataSource.getUpcomingEvents(pageNumber: pageNumber, pageSize: pageSize);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<List<EventModel>>> getMyEvents() async {
    try {
      final result = await _remoteDataSource.getMyEvents();
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<EventModel?>> getEventById(String id) async {
    try {
      final result = await _remoteDataSource.getEventById(id);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<List<RoundModel>>> getRoundsByEvent(String eventId) async {
    try {
      final result = await _remoteDataSource.getRoundsByEvent(eventId);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<List<TrackModel>>> getTracksByEvent(String eventId) async {
    try {
      final result = await _remoteDataSource.getTracksByEvent(eventId);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
