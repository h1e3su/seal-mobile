import '../../../core/base/base_viewmodel.dart';
import '../../../core/context/user_role_context.dart';
import '../../../data/models/team/team_model.dart';
import '../../../data/repositories/team_repository.dart';

class MentorDashboardViewModel extends BaseViewModel {
  final TeamRepository _teamRepository;
  final UserRoleContext _userRoleContext;

  MentorDashboardViewModel(
    this._teamRepository,
    this._userRoleContext,
  );

  List<TeamModel> _teams = [];
  List<TeamModel> get teams => _teams;

  ActiveRole? get currentRole => _userRoleContext.currentRole;
  String? get currentTrackId => _userRoleContext.currentRole?.trackId;

  Future<void> loadDashboard([String? trackId]) async {
    setLoading();
    final targetTrackId = trackId ?? currentTrackId;
    if (targetTrackId == null || targetTrackId.isEmpty) {
      _teams = [];
      setSuccess();
      return;
    }

    try {
      _teams = await _teamRepository.getTeams(trackId: targetTrackId);
      setSuccess();
    } catch (e) {
      setError('Không thể tải danh sách đội thi trong Hạng mục');
    }
  }
}
