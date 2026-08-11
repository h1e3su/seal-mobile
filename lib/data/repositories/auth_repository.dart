import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth/login_request.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/register_request.dart';
import '../models/user/user_profile_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<ApiResult<AuthResponse>> login(String username, String password) async {
    try {
      final result = await _dataSource.login(
        LoginRequest(email: username, password: password),
      );
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<UserProfileModel>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final result = await _dataSource.register(
        RegisterRequest(email: email, password: password, fullName: fullName),
      );
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
