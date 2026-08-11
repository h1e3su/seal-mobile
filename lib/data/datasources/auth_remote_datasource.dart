import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_response.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/login_request.dart';
import '../models/auth/register_request.dart';
import '../models/user/user_profile_model.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSource(this._dioClient);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data;
  }

  Future<UserProfileModel> register(RegisterRequest request) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
    );
    return apiResponse.data;
  }
}
