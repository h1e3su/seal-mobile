import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/paginated_data.dart';
import '../models/event/event_model.dart';
import '../models/event/round_model.dart';
import '../models/event/track_model.dart';

class EventRemoteDataSource {
  final DioClient _dioClient;

  const EventRemoteDataSource(this._dioClient);

  Future<PaginatedData<EventModel>> getEvents({int pageNumber = 1, int pageSize = 20}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.events,
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );
    return PaginatedData<EventModel>.fromJson(
      response.data,
      (json) => EventModel.fromJson(json),
    );
  }

  Future<PaginatedData<EventModel>> getUpcomingEvents({int pageNumber = 1, int pageSize = 20}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.upcomingEvents,
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );
    return PaginatedData<EventModel>.fromJson(
      response.data,
      (json) => EventModel.fromJson(json),
    );
  }

  Future<List<EventModel>> getMyEvents() async {
    final response = await _dioClient.dio.get(ApiEndpoints.myEvents);
    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => EventModel.fromJson(json))
          .toList();
    }
    if (response.data is Map<String, dynamic>) {
      final list = response.data['data'] as List? ?? response.data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => EventModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<EventModel?> getEventById(String id) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.events}/$id');
    if (response.data != null) {
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'] ?? response.data;
        if (data is Map<String, dynamic>) {
          return EventModel.fromJson(data);
        }
      }
    }
    return null;
  }

  Future<List<RoundModel>> getRoundsByEvent(String eventId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.roundsByEvent,
      queryParameters: {'eventId': eventId},
    );
    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => RoundModel.fromJson(json))
          .toList();
    }
    if (response.data is Map<String, dynamic>) {
      final list = response.data['data'] as List? ?? response.data['items'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => RoundModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<List<TrackModel>> getTracksByEvent(String eventId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.tracksByEvent,
      queryParameters: {'eventId': eventId},
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
}
