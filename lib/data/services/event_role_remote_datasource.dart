import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/paginated_data.dart';
import '../models/event_role/event_role_model.dart';

class EventRoleRemoteDataSource {
  final DioClient _dioClient;

  const EventRoleRemoteDataSource(this._dioClient);

  Future<PaginatedData<EventRoleModel>> getUserRoles() async {
    final response = await _dioClient.dio.get(ApiEndpoints.userEventRoles);
    return PaginatedData<EventRoleModel>.fromJson(
      response.data,
      (item) => EventRoleModel.fromJson(item),
    );
  }

  Future<EventRoleModel?> getUserRoleInEvent(String eventId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.userRoleInEvent,
      queryParameters: {'eventId': eventId},
    );
    if (response.data != null && response.data is Map<String, dynamic>) {
      return EventRoleModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> respondRoleInvitation(String invitationId, bool isAccepted) async {
    await _dioClient.dio.post(
      '${ApiEndpoints.eventRoleInvitations}/$invitationId/respond',
      queryParameters: {'isAccepted': isAccepted},
    );
  }
}
