import '../../../core/base/base_viewmodel.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileViewModel extends BaseViewModel {
  final UserRepository _userRepository;

  ProfileViewModel(this._userRepository);
}
