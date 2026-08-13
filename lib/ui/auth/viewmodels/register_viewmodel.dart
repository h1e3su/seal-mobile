import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository);

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
    
    final registerResult = await _authRepository.register(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
    );

    switch (registerResult) {
      case Success():
        setSuccess();
        return true;
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
        return false;
    }
    return false;
  }
}
