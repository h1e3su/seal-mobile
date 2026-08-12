import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/event_role/event_role_model.dart';
import '../../../data/repositories/event_role_repository.dart';

class UserRoleViewModel extends BaseViewModel {
  final EventRoleRepository _eventRoleRepository;

  List<EventRoleModel> _userRoles = [];
  bool _isFetched = false;

  UserRoleViewModel(this._eventRoleRepository);

  List<EventRoleModel> get userRoles => _userRoles;
  bool get isFetched => _isFetched;

  bool get hasStudentRole => _userRoles.any((r) => r.isStudent);
  bool get hasMentorRole => _userRoles.any((r) => r.isMentor);
  bool get hasJudgeRole => _userRoles.any((r) => r.isJudge);
  bool get hasECRole => _userRoles.any((r) => r.isEC);
  bool get hasAnyRole => _userRoles.isNotEmpty;

  List<EventRoleModel> get mentorRoles => _userRoles.where((r) => r.isMentor).toList();
  List<EventRoleModel> get studentRoles => _userRoles.where((r) => r.isStudent).toList();

  Future<void> fetchUserRoles() async {
    setLoading();
    final result = await _eventRoleRepository.getUserRoles();
    switch (result) {
      case Success(data: final paginated):
        _userRoles = paginated.data;
        _isFetched = true;
        setSuccess();
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
    }
  }

  void clear() {
    _userRoles = [];
    _isFetched = false;
    setIdle();
  }
}
