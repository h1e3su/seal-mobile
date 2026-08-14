import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/invitation/my_invitations_model.dart';
import '../models/user/school_model.dart';
import '../models/user/user_profile_model.dart';
import '../models/user/user_rejection_model.dart';

class UserRemoteDataSource {
  final DioClient _dioClient;

  const UserRemoteDataSource(this._dioClient);

  Future<UserProfileModel> getProfile() async {
    final response = await _dioClient.dio.get(ApiEndpoints.profile);
    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;
    return UserProfileModel.fromJson(data as Map<String, dynamic>);
  }

  Future<MyInvitationsModel> getMyInvitations() async {
    final response = await _dioClient.dio.get(ApiEndpoints.myInvitations);
    final data = response.data is Map<String, dynamic> && response.data['data'] != null
        ? response.data['data']
        : response.data;
    if (data is Map<String, dynamic>) {
      return MyInvitationsModel.fromJson(data);
    }
    return const MyInvitationsModel();
  }

  Future<UserProfileModel> updateStudentProfile({
    String? studentCode,
    String? schoolId,
    String? studentCardImageUrl,
  }) async {
    final body = <String, dynamic>{
      'studentCode': ?studentCode,
      'schoolId': ?schoolId,
      'studentCardImageUrl': ?studentCardImageUrl,
    };

    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.studentProfiles,
        data: body,
      );
      final data = response.data is Map<String, dynamic> && response.data['data'] != null
          ? response.data['data']
          : response.data;
      return UserProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      final response = await _dioClient.dio.put(
        ApiEndpoints.studentProfiles,
        data: body,
      );
      final data = response.data is Map<String, dynamic> && response.data['data'] != null
          ? response.data['data']
          : response.data;
      return UserProfileModel.fromJson(data as Map<String, dynamic>);
    }
  }

  Future<void> requestUnblock({required String email, required String reason}) async {
    await _dioClient.dio.post(
      ApiEndpoints.requestUnblock,
      data: {'email': email, 'reason': reason},
    );
  }

  Future<List<UserRejectionModel>> getMyRejections() async {
    final response = await _dioClient.dio.get(ApiEndpoints.userRejections);
    if (response.data is List) {
      return (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => UserRejectionModel.fromJson(json))
          .toList();
    }
    if (response.data is Map<String, dynamic>) {
      final raw = response.data['data'] ?? response.data['items'];
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map((json) => UserRejectionModel.fromJson(json))
            .toList();
      }
      if (raw is Map<String, dynamic>) {
        final list = raw['data'] as List? ?? raw['items'] as List? ?? [];
        return list
            .whereType<Map<String, dynamic>>()
            .map((json) => UserRejectionModel.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<List<SchoolModel>> getSchools() async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.schools,
        queryParameters: {'PageNumber': 1, 'PageSize': 200},
      );
      return _parseSchoolsList(response.data);
    } catch (_) {
      // Fallback without query params if backend rejects them
      final response = await _dioClient.dio.get(ApiEndpoints.schools);
      return _parseSchoolsList(response.data);
    }
  }

  List<SchoolModel> _parseSchoolsList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((json) => SchoolModel.fromJson(json))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final raw = data['data'] ?? data['items'];
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map((json) => SchoolModel.fromJson(json))
            .toList();
      }
      if (raw is Map<String, dynamic>) {
        final innerList = raw['data'] as List? ?? raw['items'] as List? ?? [];
        return innerList
            .whereType<Map<String, dynamic>>()
            .map((json) => SchoolModel.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<FptStudentMockModel?> verifyFptStudent(String studentCode) async {
    final response = await _dioClient.dio.get('${ApiEndpoints.fptMockStudent}/$studentCode');
    if (response.data != null) {
      final data = response.data is Map<String, dynamic> && response.data['data'] != null
          ? response.data['data']
          : response.data;
      if (data is Map<String, dynamic>) {
        return FptStudentMockModel.fromJson(data);
      }
    }
    return null;
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _dioClient.dio.put(
      ApiEndpoints.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}
