import 'team_member_model.dart';
import 'team_invitation_model.dart';

class TeamModel {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final String? eventId;
  final String? eventName;
  final String? trackId;
  final String? trackName;
  final String? leaderId;
  final String? leaderName;
  final bool isLeader;
  final String status; // Forming, PendingApproval, Registered, Rejected, Disqualified
  final String? lastRejectReason;
  final List<TeamMemberModel> members;
  final List<TeamInvitationModel> pendingInvitations;

  const TeamModel({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    this.eventId,
    this.eventName,
    this.trackId,
    this.trackName,
    this.leaderId,
    this.leaderName,
    this.isLeader = false,
    this.status = 'Forming',
    this.lastRejectReason,
    this.members = const [],
    this.pendingInvitations = const [],
  });

  bool get isForming => status == 'Forming';
  bool get isPendingApproval => status == 'PendingApproval';
  bool get isRegistered => status == 'Registered';
  bool get isRejected => status == 'Rejected';
  bool get isConfirmed => isRegistered;
  int get memberCount => members.length;

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    var rawMembers = json['members'] as List? ?? json['teamMembers'] as List? ?? [];
    List<TeamMemberModel> memberList = rawMembers
        .whereType<Map<String, dynamic>>()
        .map((m) => TeamMemberModel.fromJson(m))
        .toList();

    var rawInvites = json['pendingInvitations'] as List? ?? json['invitations'] as List? ?? [];
    List<TeamInvitationModel> inviteList = rawInvites
        .whereType<Map<String, dynamic>>()
        .map((i) => TeamInvitationModel.fromJson(i))
        .toList();

    final leaderUserId = json['leaderUserId']?.toString() ??
        json['leaderId']?.toString() ??
        json['teamLeaderId']?.toString();

    final isLeaderVal = json['isLeader'] == true ||
        (leaderUserId != null && memberList.any((m) => m.userId == leaderUserId && m.isLeader));

    return TeamModel(
      id: (json['id'] ?? json['teamId'] ?? '').toString(),
      name: (json['name'] ?? json['teamName'] ?? 'Đội thi').toString(),
      description: json['description']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      eventId: json['eventId']?.toString(),
      eventName: json['eventName']?.toString() ?? json['event']?['name']?.toString(),
      trackId: json['trackId']?.toString(),
      trackName: json['trackName']?.toString() ?? json['track']?['name']?.toString(),
      leaderId: leaderUserId,
      leaderName: json['leaderName']?.toString() ?? json['leader']?['fullName']?.toString(),
      isLeader: isLeaderVal,
      status: (json['status'] ?? 'Forming').toString(),
      lastRejectReason: json['lastRejectReason']?.toString() ??
          json['rejectReason']?.toString() ??
          (json['status'] == 'Rejected' ? json['description']?.toString() : null),
      members: memberList,
      pendingInvitations: inviteList,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'avatarUrl': avatarUrl,
      'eventId': eventId,
      'eventName': eventName,
      'trackId': trackId,
      'trackName': trackName,
      'leaderUserId': leaderId,
      'leaderId': leaderId,
      'leaderName': leaderName,
      'isLeader': isLeader,
      'status': status,
      'lastRejectReason': lastRejectReason,
      'members': members.map((m) => m.toJson()).toList(),
      'pendingInvitations': pendingInvitations.map((i) => i.toJson()).toList(),
    };
  }
}
