import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../models/invitation/my_invitations_model.dart';
import '../models/user/school_model.dart';
import '../models/user/user_profile_model.dart';
import '../models/user/user_rejection_model.dart';
import '../services/user_remote_datasource.dart';

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

  Future<ApiResult<MyInvitationsModel>> getMyInvitations() async {
    try {
      final result = await _remoteDataSource.getMyInvitations();
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<UserProfileModel>> updateStudentProfile({
    String? studentCode,
    String? schoolId,
    String? studentCardImageUrl,
  }) async {
    try {
      final result = await _remoteDataSource.updateStudentProfile(
        studentCode: studentCode,
        schoolId: schoolId,
        studentCardImageUrl: studentCardImageUrl,
      );
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> requestUnblock({required String email, required String reason}) async {
    try {
      await _remoteDataSource.requestUnblock(email: email, reason: reason);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<List<UserRejectionModel>>> getMyRejections() async {
    try {
      final result = await _remoteDataSource.getMyRejections();
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<List<SchoolModel>>> getSchools() async {
    try {
      final result = await _remoteDataSource.getSchools();
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<FptStudentMockModel?>> verifyFptStudent(String studentCode) async {
    try {
      final result = await _remoteDataSource.verifyFptStudent(studentCode);
      return Success(result);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<void>> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await _remoteDataSource.changePassword(currentPassword: currentPassword, newPassword: newPassword);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
