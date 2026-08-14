import 'package:flutter_test/flutter_test.dart';
import 'package:seal/core/network/api_result.dart';
import 'package:seal/data/models/team/team_member_model.dart';
import 'package:seal/data/models/team/team_model.dart';
import 'package:seal/data/repositories/team_repository.dart';
import 'package:seal/ui/team/viewmodels/team_viewmodel.dart';

// Fake TeamRepository for deterministic testing without network dependencies
class FakeTeamRepository implements TeamRepository {
  TeamModel? fakeMyTeam;
  bool shouldFail = false;

  @override
  Future<ApiResult<TeamModel?>> getMyTeam({String? eventId}) async {
    if (shouldFail) return Failure(Exception('Network Error'));
    return Success(fakeMyTeam);
  }

  @override
  Future<ApiResult<List<TeamModel>>> getTeams({String? trackId, String? eventId, String? status}) async {
    return const Success([]);
  }

  @override
  Future<ApiResult<TeamModel>> getTeamById(String id) async {
    if (fakeMyTeam != null) return Success(fakeMyTeam!);
    return Failure(Exception('Not found'));
  }

  @override
  Future<ApiResult<TeamModel>> createTeam({
    required String name,
    required String eventId,
    String? description,
    String? avatarUrl,
  }) async {
    final newTeam = TeamModel(id: 'team_new', name: name, eventId: eventId, isLeader: true);
    fakeMyTeam = newTeam;
    return Success(newTeam);
  }

  @override
  Future<ApiResult<void>> inviteMember(String teamId, String invitedUserIdOrEmail) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> respondInvitation(String invitationId, bool isAccepted) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> removeMember(String teamId, String userId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> leaveTeam(String teamId) async {
    fakeMyTeam = null;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> transferLeadership(String teamId, String newLeaderUserId) async {
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> confirmRegistration(String teamId) async {
    if (shouldFail) return Failure(Exception('Confirm Error'));
    return const Success(null);
  }
}

void main() {
  group('TeamViewModel Unit Tests', () {
    late FakeTeamRepository repository;
    late TeamViewModel viewModel;

    setUp(() {
      repository = FakeTeamRepository();
      viewModel = TeamViewModel(repository);
    });

    test('Initial user state without team should be TeamUserState.unassigned', () {
      expect(viewModel.userState, TeamUserState.unassigned);
      expect(viewModel.isUnassigned, true);
      expect(viewModel.isLeader, false);
      expect(viewModel.isMember, false);
    });

    test('When user is the team leader, userState should be TeamUserState.leader', () async {
      repository.fakeMyTeam = TeamModel(
        id: 'team_01',
        name: 'Cyber Operatives',
        leaderId: 'usr_leader_01',
        isLeader: true,
      );
      viewModel.setCurrentUserId('usr_leader_01');

      await viewModel.loadMyTeam();

      expect(viewModel.userState, TeamUserState.leader);
      expect(viewModel.isLeader, true);
      expect(viewModel.isMember, false);
    });

    test('When members count is less than 3, canConfirmRegistration returns false', () async {
      repository.fakeMyTeam = TeamModel(
        id: 'team_01',
        name: 'Cyber Operatives',
        isLeader: true,
        members: [
          TeamMemberModel(id: '1', userId: 'u1', fullName: 'User 1', email: 'u1@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
          TeamMemberModel(id: '2', userId: 'u2', fullName: 'User 2', email: 'u2@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
        ],
      );

      await viewModel.loadMyTeam();
      expect(viewModel.canConfirmRegistration, false);
    });

    test('When team has 3 members but 1 is unverified, canConfirmRegistration returns false', () async {
      repository.fakeMyTeam = TeamModel(
        id: 'team_01',
        name: 'Cyber Operatives',
        isLeader: true,
        members: [
          TeamMemberModel(id: '1', userId: 'u1', fullName: 'User 1', email: 'u1@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
          TeamMemberModel(id: '2', userId: 'u2', fullName: 'User 2', email: 'u2@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
          TeamMemberModel(id: '3', userId: 'u3', fullName: 'User 3', email: 'u3@fpt.edu.vn', isAccepted: true, registrationStatus: 'Pending'),
        ],
      );

      await viewModel.loadMyTeam();
      expect(viewModel.canConfirmRegistration, false);
    });

    test('When team has 3-5 members and 100% verified, canConfirmRegistration returns true', () async {
      repository.fakeMyTeam = TeamModel(
        id: 'team_01',
        name: 'Cyber Operatives',
        isLeader: true,
        members: [
          TeamMemberModel(id: '1', userId: 'u1', fullName: 'User 1', email: 'u1@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
          TeamMemberModel(id: '2', userId: 'u2', fullName: 'User 2', email: 'u2@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
          TeamMemberModel(id: '3', userId: 'u3', fullName: 'User 3', email: 'u3@fpt.edu.vn', isAccepted: true, registrationStatus: 'Approved'),
        ],
      );

      await viewModel.loadMyTeam();
      expect(viewModel.canConfirmRegistration, true);
    });

    test('When team is Rejected, lastRejectReason provides rejection message', () async {
      repository.fakeMyTeam = TeamModel(
        id: 'team_01',
        name: 'Cyber Operatives',
        status: 'Rejected',
        lastRejectReason: 'Chưa nộp ảnh thẻ sinh viên đầy đủ',
      );

      await viewModel.loadMyTeam();
      expect(viewModel.lastRejectReason, 'Chưa nộp ảnh thẻ sinh viên đầy đủ');
    });
  });
}
