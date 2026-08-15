import '../../../app/di/locator.dart';
import '../../../core/base/base_viewmodel.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/context/user_role_context.dart';
import '../../../core/network/api_result.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/user/school_model.dart';
import '../../../data/models/user/user_profile_model.dart';
import '../../../data/models/user/user_rejection_model.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileViewModel extends BaseViewModel {
  final UserRepository _userRepository;

  UserProfileModel? _profile;
  List<UserRejectionModel> _rejections = [];
  List<SchoolModel> _schools = [];
  FptStudentMockModel? _verifiedFptStudent;

  ProfileViewModel(this._userRepository);

  UserProfileModel? get profile => _profile;
  List<UserRejectionModel> get rejections => _rejections;
  List<SchoolModel> get schools => _schools;
  FptStudentMockModel? get verifiedFptStudent => _verifiedFptStudent;

  bool get isApproved => _profile?.isApproved ?? false;
  bool get isRejected => _profile?.isRejected ?? false;
  bool get isPending => _profile?.isPending ?? true;

  Future<bool> fetchProfile() async {
    setLoading();
    final result = await _userRepository.getProfile();
    if (result is Success<UserProfileModel>) {
      _profile = result.data;
      setSuccess();
      return true;
    } else if (result is Failure<UserProfileModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> fetchSchools() async {
    final result = await _userRepository.getSchools();
    if (result is Success<List<SchoolModel>>) {
      _schools = result.data;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<FptStudentMockModel?> checkFptStudent(String studentCode) async {
    setLoading();
    final result = await _userRepository.verifyFptStudent(studentCode);
    if (result is Success<FptStudentMockModel>) {
      _verifiedFptStudent = result.data;
      setSuccess();
      return result.data;
    } else if (result is Failure<FptStudentMockModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return null;
    }
    return null;
  }

  Future<bool> updateStudentProfile({
    String? studentCode,
    String? schoolId,
    String? studentCardImageUrl,
  }) async {
    setLoading();
    final result = await _userRepository.updateStudentProfile(
      studentCode: studentCode,
      schoolId: schoolId,
      studentCardImageUrl: studentCardImageUrl,
    );
    if (result is Success<UserProfileModel>) {
      _profile = result.data;
      setSuccess();
      return true;
    } else if (result is Failure<UserProfileModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> requestUnblock({required String email, required String reason}) async {
    setLoading();
    final result = await _userRepository.requestUnblock(email: email, reason: reason);
    if (result is Success<void>) {
      setSuccess();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<void> fetchRejectionHistory() async {
    setLoading();
    final result = await _userRepository.getMyRejections();
    if (result is Success<List<UserRejectionModel>>) {
      _rejections = result.data;
      setSuccess();
    } else if (result is Failure<List<UserRejectionModel>>) {
      setError(ErrorMapper.toMessage(result.exception));
    }
  }

  Future<bool> changePassword({required String currentPassword, required String newPassword}) async {
    setLoading();
    final result = await _userRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (result is Success<void>) {
      setSuccess();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<void> logout() async {
    final storage = locator<SecureStorageService>();
    await storage.delete(StorageKeys.accessToken);
    await storage.delete(StorageKeys.refreshToken);

    // Clear user role context to prevent role leakage
    locator<UserRoleContext>().clear();

    _profile = null;
    _rejections = [];
    _verifiedFptStudent = null;
    setIdle();
  }
}
