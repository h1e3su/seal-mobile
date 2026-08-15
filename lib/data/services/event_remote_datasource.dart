import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/paginated_data.dart';
import '../models/event/event_model.dart';
import '../models/event/round_model.dart';
import '../models/event/track_model.dart';

import '../../core/utils/response_parser.dart';

class EventRemoteDataSource {
  final DioClient _dioClient;

  const EventRemoteDataSource(this._dioClient);

  Future<PaginatedData<EventModel>> getEvents({
    int pageNumber = 1,
    int pageSize = 20,
    String? searchTerm,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      queryParams['search'] = searchTerm.trim();
      queryParams['searchTerm'] = searchTerm.trim();
    }
    final response = await _dioClient.dio.get(
      ApiEndpoints.events,
      queryParameters: queryParams,
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
    final rawList = ResponseParser.extractList(response.data);
    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => EventModel.fromJson(json))
        .toList();
  }

  Future<EventModel?> getEventById(String id) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.events}/$id');
    final map = ResponseParser.extractMap(response.data);
    if (map != null) {
      return EventModel.fromJson(map);
    }
    return null;
  }

  Future<List<RoundModel>> getRoundsByEvent(String eventId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.roundsByEvent,
      queryParameters: {'eventId': eventId},
    );
    final rawList = ResponseParser.extractList(response.data);
    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => RoundModel.fromJson(json))
        .toList();
  }

  Future<List<TrackModel>> getTracksByEvent(String eventId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.tracksByEvent,
      queryParameters: {'eventId': eventId},
    );
    final rawList = ResponseParser.extractList(response.data);
    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => TrackModel.fromJson(json))
        .toList();
  }
}
