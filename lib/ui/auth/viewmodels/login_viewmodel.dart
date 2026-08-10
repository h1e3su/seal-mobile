import '../../../core/base/base_viewmodel.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);
}
