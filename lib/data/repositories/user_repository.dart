import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user/user_profile_model.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepository(this._remoteDataSource);

  Future<ApiResult<UserProfileModel>> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
