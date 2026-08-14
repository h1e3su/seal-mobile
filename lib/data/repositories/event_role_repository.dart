import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/network/paginated_data.dart';
import '../services/event_role_remote_datasource.dart';
import '../models/event_role/event_role_model.dart';

class EventRoleRepository {
  final EventRoleRemoteDataSource _remoteDataSource;

  const EventRoleRepository(this._remoteDataSource);

  Future<ApiResult<PaginatedData<EventRoleModel>>> getUserRoles() async {
    try {
      final data = await _remoteDataSource.getUserRoles();
      return Success(data);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<EventRoleModel?>> getUserRoleInEvent(String eventId) async {
    try {
      final role = await _remoteDataSource.getUserRoleInEvent(eventId);
      return Success(role);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> respondRoleInvitation(String invitationId, bool isAccepted) async {
    try {
      await _remoteDataSource.respondRoleInvitation(invitationId, isAccepted);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
