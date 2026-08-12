import 'team_member_model.dart';

class TeamModel {
  final String id;
  final String name;
  final String? description;
  final String? eventId;
  final String? eventName;
  final String? trackId;
  final String? trackName;
  final String? leaderId;
  final String? leaderName;
  final String status; // Forming, PendingApproval, Registered, Rejected, Disqualified
  final List<TeamMemberModel> members;

  const TeamModel({
    required this.id,
    required this.name,
    this.description,
    this.eventId,
    this.eventName,
    this.trackId,
    this.trackName,
    this.leaderId,
    this.leaderName,
    this.status = 'Forming',
    this.members = const [],
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    var rawMembers = json['members'] as List? ?? json['teamMembers'] as List? ?? [];
    List<TeamMemberModel> memberList = rawMembers
        .map((m) => TeamMemberModel.fromJson(m as Map<String, dynamic>))
        .toList();

    return TeamModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['teamName']?.toString() ?? 'Đội thi',
      description: json['description']?.toString(),
      eventId: json['eventId']?.toString(),
      eventName: json['eventName']?.toString() ?? json['event']?['name']?.toString(),
      trackId: json['trackId']?.toString(),
      trackName: json['trackName']?.toString() ?? json['track']?['name']?.toString(),
      leaderId: json['leaderId']?.toString() ?? json['teamLeaderId']?.toString(),
      leaderName: json['leaderName']?.toString() ?? json['leader']?['fullName']?.toString(),
      status: json['status']?.toString() ?? 'Forming',
      members: memberList,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'eventId': eventId,
      'eventName': eventName,
      'trackId': trackId,
      'trackName': trackName,
      'leaderId': leaderId,
      'leaderName': leaderName,
      'status': status,
      'members': members.map((m) => m.toJson()).toList(),
    };
  }
}
