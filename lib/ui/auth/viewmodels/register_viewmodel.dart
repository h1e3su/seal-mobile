import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  RegisterViewModel(this._authRepository, this._secureStorage);

  String? emailError;
  String? passwordError;
  String? fullNameError;

  bool _validate(String email, String password, String fullName) {
    emailError = null;
    passwordError = null;
    fullNameError = null;

    if (email.trim().isEmpty || !email.contains('@')) {
      emailError = 'Email không hợp lệ';
    }
    if (password.isEmpty || password.length < 6) {
      passwordError = 'Mật khẩu phải từ 6 ký tự';
    }
    if (fullName.trim().isEmpty) {
      fullNameError = 'Họ tên không được để trống';
    }
    notifyListeners();
    return emailError == null && passwordError == null && fullNameError == null;
  }

  Future<bool> register(String email, String password, String fullName) async {
    if (!_validate(email, password, fullName)) return false;

    setLoading();
    
    // 1. Call Register
    final registerResult = await _authRepository.register(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
    );

    switch (registerResult) {
      case Success():
        // 2. Auto-login on success
        final loginResult = await _authRepository.login(email.trim(), password);
        switch (loginResult) {
          case Success(data: final authResponse):
            if (authResponse.accessToken == null || authResponse.refreshToken == null) {
              setError('Đăng ký thành công nhưng đăng nhập tự động thất bại.');
              return false;
            }
            await _secureStorage.write(StorageKeys.accessToken, authResponse.accessToken!);
            await _secureStorage.write(StorageKeys.refreshToken, authResponse.refreshToken!);
            setSuccess();
            return true;
          case Failure(exception: final ex):
            setError('Đăng ký thành công nhưng không thể tự động đăng nhập: ${ErrorMapper.toMessage(ex)}');
            return false;
        }
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
        return false;
    }
  }
}
