import 'package:flutter/foundation.dart';
import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;
  final GoogleAuthService _googleAuthService;

  LoginViewModel(
    this._authRepository,
    this._secureStorage,
    this._googleAuthService,
  );

  String? usernameError;
  String? passwordError;

  bool _validate(String username, String password) {
    usernameError = null;
    passwordError = null;

    if (username.trim().isEmpty) {
      usernameError = 'Tên đăng nhập không được để trống';
    }
    if (password.isEmpty || password.length < 6) {
      passwordError = 'Mật khẩu phải từ 6 ký tự';
    }
    notifyListeners();
    return usernameError == null && passwordError == null;
  }

  Future<bool> login(String username, String password) async {
    if (!_validate(username, password)) return false;

    setLoading();
    final result = await _authRepository.login(username.trim(), password);

    switch (result) {
      case Success(data: final authResponse):
        if (authResponse.accessToken == null || authResponse.refreshToken == null) {
          setError('Phản hồi từ máy chủ không hợp lệ.');
          return false;
        }
        await _secureStorage.write(StorageKeys.accessToken, authResponse.accessToken!);
        await _secureStorage.write(StorageKeys.refreshToken, authResponse.refreshToken!);
        setSuccess();
        return true;
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
        return false;
    }
    return false;
  }

  Future<bool> loginWithGoogle() async {
    try {
      setLoading();
      final idToken = await _googleAuthService.signInAndGetIdToken();
      if (idToken == null) {
        setIdle();
        return false; // User cancelled
      }

      final result = await _authRepository.loginWithGoogle(idToken);
      switch (result) {
        case Success(data: final authResponse):
          if (authResponse.accessToken == null || authResponse.refreshToken == null) {
            setError('Phản hồi từ máy chủ không hợp lệ.');
            return false;
          }
          await _secureStorage.write(StorageKeys.accessToken, authResponse.accessToken!);
          await _secureStorage.write(StorageKeys.refreshToken, authResponse.refreshToken!);
          setSuccess();
          return true;
        case Failure(exception: final ex):
          setError(ErrorMapper.toMessage(ex));
          return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[LoginViewModel ERROR] Google Login exception: $e');
      debugPrint('$stackTrace');
      setError('Đăng nhập Google thất bại (Mã lỗi: ApiException 10/Configuration)');
      return false;
    }
    return false;
  }
}
