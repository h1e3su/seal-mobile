import '../../../core/base/base_viewmodel.dart';
import '../../../core/context/user_role_context.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/repositories/event_role_repository.dart';

class HomeViewModel extends BaseViewModel {
  final EventRoleRepository _eventRoleRepository;
  final UserRoleContext _roleContext;

  HomeViewModel(this._eventRoleRepository, this._roleContext);

  UserRoleContext get roleContext => _roleContext;

  Future<void> init() async {
    setLoading();
    final result = await _eventRoleRepository.getUserRoles();
    switch (result) {
      case Success(data: final paginated):
        _roleContext.setRoles(paginated.data);
        setSuccess();
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
    }
  }
}
