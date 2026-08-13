import '../../../app/di/locator.dart';
import '../../../core/base/base_viewmodel.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/context/user_role_context.dart';
import '../../../core/network/api_result.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../data/models/user/user_profile_model.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileViewModel extends BaseViewModel {
  final UserRepository _userRepository;

  ProfileViewModel(this._userRepository);

  UserProfileModel? _profile;
  UserProfileModel? get profile => _profile;

  bool get isApproved => _profile?.isApproved ?? false;
  bool get isRejected => _profile?.isRejected ?? false;
  bool get isPending => _profile?.isPending ?? true;

  Future<bool> fetchProfile() async {
    setLoading();
    final result = await _userRepository.getProfile();
    switch (result) {
      case Success(data: final profile):
        _profile = profile;
        setSuccess();
        return true;
      case Failure(exception: final ex):
        setError(ex.toString());
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
    setIdle();
  }
}
