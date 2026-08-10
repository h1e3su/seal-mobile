import '../../../core/base/base_viewmodel.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  RegisterViewModel(this._authRepository);
}
