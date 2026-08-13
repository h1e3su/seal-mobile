import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user/user_profile_model.dart';

class UserRemoteDataSource {
  final DioClient _dioClient;

  const UserRemoteDataSource(this._dioClient);

  Future<UserProfileModel> getProfile() async {
    final response = await _dioClient.dio.get(ApiEndpoints.profile);
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data;
  }
}
