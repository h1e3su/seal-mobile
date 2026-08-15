import '../team/team_invitation_model.dart';

class EventRoleInvitationModel {
  final String id;
  final String eventId;
  final String eventName;
  final String roleName;
  final String? trackId;
  final String? trackName;
  final String status;
  final DateTime? createdDate;

  const EventRoleInvitationModel({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.roleName,
    this.trackId,
    this.trackName,
    this.status = 'Pending',
    this.createdDate,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isMentor => roleName.toLowerCase() == 'mentor';
  bool get isJudge => roleName.toLowerCase() == 'judge';

  factory EventRoleInvitationModel.fromJson(Map<String, dynamic> json) {
    return EventRoleInvitationModel(
      id: (json['id'] ?? json['invitationId'] ?? '').toString(),
      eventId: (json['eventId'] ?? '').toString(),
      eventName: (json['eventName'] ?? 'Sự kiện').toString(),
      roleName: (json['roleName'] ?? 'Mentor').toString(),
      trackId: json['trackId']?.toString(),
      trackName: json['trackName']?.toString(),
      status: (json['status'] ?? 'Pending').toString(),
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'].toString())
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'eventName': eventName,
      'roleName': roleName,
      'trackId': trackId,
      'trackName': trackName,
      'status': status,
      'createdDate': createdDate?.toIso8601String(),
    };
  }
}

class MyInvitationsModel {
  final int totalPendingInvitations;
  final List<TeamInvitationModel> teamInvitations;
  final List<EventRoleInvitationModel> eventRoleInvitations;

  const MyInvitationsModel({
    this.totalPendingInvitations = 0,
    this.teamInvitations = const [],
    this.eventRoleInvitations = const [],
  });

  factory MyInvitationsModel.fromJson(Map<String, dynamic> json) {
    final rawTeams = json['teamInvitations'] as List? ?? [];
    final rawRoles = json['eventRoleInvitations'] as List? ?? [];

    final teams = rawTeams
        .whereType<Map<String, dynamic>>()
        .map((t) => TeamInvitationModel.fromJson(t))
        .toList();

    final roles = rawRoles
        .whereType<Map<String, dynamic>>()
        .map((r) => EventRoleInvitationModel.fromJson(r))
        .toList();

    final total = (json['totalPendingInvitations'] as num?)?.toInt() ?? (teams.length + roles.length);

    return MyInvitationsModel(
      totalPendingInvitations: total,
      teamInvitations: teams,
      eventRoleInvitations: roles,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalPendingInvitations': totalPendingInvitations,
      'teamInvitations': teamInvitations.map((t) => t.toJson()).toList(),
      'eventRoleInvitations': eventRoleInvitations.map((r) => r.toJson()).toList(),
    };
  }
}
