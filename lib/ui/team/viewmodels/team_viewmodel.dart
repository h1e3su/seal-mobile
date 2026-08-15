import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/team/team_model.dart';
import '../../../data/repositories/team_repository.dart';

enum TeamUserState { unassigned, member, leader }

class TeamViewModel extends BaseViewModel {
  final TeamRepository _teamRepository;

  TeamModel? _myTeam;
  String? _currentUserId;

  TeamViewModel(this._teamRepository);

  TeamModel? get myTeam => _myTeam;

  void setCurrentUserId(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  TeamUserState get userState {
    if (_myTeam == null) return TeamUserState.unassigned;
    if (_myTeam!.isLeader) return TeamUserState.leader;
    if (_currentUserId != null && _myTeam!.leaderId == _currentUserId) {
      return TeamUserState.leader;
    }
    return TeamUserState.member;
  }

  bool get isLeader => userState == TeamUserState.leader;
  bool get isMember => userState == TeamUserState.member;
  bool get isUnassigned => userState == TeamUserState.unassigned;

  bool get canConfirmRegistration {
    if (_myTeam == null || !isLeader) return false;
    final members = _myTeam!.members;
    if (members.length < 3 || members.length > 5) return false;
    // Kiểm tra tất cả thành viên đã được duyệt hồ sơ sinh viên
    return members.every((m) => m.isVerified);
  }

  String? get lastRejectReason => _myTeam?.lastRejectReason;

  Future<void> loadMyTeam([String? eventId]) async {
    setLoading();
    final result = await _teamRepository.getMyTeam(eventId: eventId);
    if (result is Success<TeamModel?>) {
      _myTeam = result.data;
      setSuccess();
    } else if (result is Failure<TeamModel?>) {
      setError(ErrorMapper.toMessage(result.exception));
    }
  }

  Future<bool> createTeam({
    required String name,
    required String eventId,
    String? description,
    String? avatarUrl,
  }) async {
    setLoading();
    final result = await _teamRepository.createTeam(
      name: name,
      eventId: eventId,
      description: description,
      avatarUrl: avatarUrl,
    );
    if (result is Success<TeamModel>) {
      _myTeam = result.data;
      setSuccess();
      return true;
    } else if (result is Failure<TeamModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> inviteMember(String emailOrUserId) async {
    if (_myTeam == null) return false;
    setLoading();
    final result = await _teamRepository.inviteMember(_myTeam!.id, emailOrUserId);
    if (result is Success<void>) {
      await loadMyTeam(_myTeam?.eventId);
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> respondInvitation(String invitationId, bool isAccepted) async {
    setLoading();
    final result = await _teamRepository.respondInvitation(invitationId, isAccepted);
    if (result is Success<void>) {
      await loadMyTeam();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> removeMember(String userId) async {
    if (_myTeam == null) return false;
    setLoading();
    final result = await _teamRepository.removeMember(_myTeam!.id, userId);
    if (result is Success<void>) {
      await loadMyTeam(_myTeam?.eventId);
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> leaveTeam() async {
    if (_myTeam == null) return false;
    setLoading();
    final result = await _teamRepository.leaveTeam(_myTeam!.id);
    if (result is Success<void>) {
      _myTeam = null;
      setSuccess();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> transferLeadership(String newLeaderUserId) async {
    if (_myTeam == null) return false;
    setLoading();
    final result = await _teamRepository.transferLeadership(_myTeam!.id, newLeaderUserId);
    if (result is Success<void>) {
      await loadMyTeam(_myTeam?.eventId);
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> confirmRegistration() async {
    if (_myTeam == null || !canConfirmRegistration) {
      setError('Chưa đủ điều kiện chốt đăng ký (Cần 3-5 thành viên và 100% đã xác minh hồ sơ)');
      return false;
    }
    setLoading();
    final result = await _teamRepository.confirmRegistration(_myTeam!.id);
    if (result is Success<void>) {
      await loadMyTeam(_myTeam?.eventId);
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  void setDemoState(TeamUserState state) {
    if (state == TeamUserState.unassigned) {
      _myTeam = null;
    } else if (state == TeamUserState.member) {
      _myTeam = const TeamModel(
        id: 'team_demo',
        name: 'CYBER OPERATIVES',
        status: 'Forming',
        isLeader: false,
      );
    } else {
      _myTeam = const TeamModel(
        id: 'team_demo',
        name: 'CYBER OPERATIVES',
        status: 'Forming',
        isLeader: true,
      );
    }
    notifyListeners();
  }
}
