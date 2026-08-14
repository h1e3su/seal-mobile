import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/invitation/my_invitations_model.dart';
import '../../../data/models/team/team_invitation_model.dart';
import '../../../data/repositories/event_role_repository.dart';
import '../../../data/repositories/team_repository.dart';
import '../../../data/repositories/user_repository.dart';

class NotificationsViewModel extends BaseViewModel {
  final UserRepository _userRepository;
  final TeamRepository _teamRepository;
  final EventRoleRepository _eventRoleRepository;

  MyInvitationsModel _invitations = const MyInvitationsModel();

  NotificationsViewModel(
    this._userRepository,
    this._teamRepository,
    this._eventRoleRepository,
  );

  MyInvitationsModel get invitations => _invitations;
  int get unreadCount => _invitations.totalPendingInvitations;
  List<TeamInvitationModel> get teamInvitations => _invitations.teamInvitations;
  List<EventRoleInvitationModel> get roleInvitations => _invitations.eventRoleInvitations;

  Future<void> loadNotifications() async {
    setLoading();
    final result = await _userRepository.getMyInvitations();
    if (result is Success<MyInvitationsModel>) {
      _invitations = result.data;
      setSuccess();
    } else if (result is Failure<MyInvitationsModel>) {
      setError(ErrorMapper.toMessage(result.exception));
    }
  }

  Future<bool> respondTeamInvitation(String invitationId, bool isAccepted) async {
    setLoading();
    final result = await _teamRepository.respondInvitation(invitationId, isAccepted);
    if (result is Success<void>) {
      await loadNotifications();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> respondRoleInvitation(String invitationId, bool isAccepted) async {
    setLoading();
    final result = await _eventRoleRepository.respondRoleInvitation(invitationId, isAccepted);
    if (result is Success<void>) {
      await loadNotifications();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }
}
