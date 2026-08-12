class EventRoleModel {
  final String id;
  final String userId;
  final String eventId;
  final String? trackId;
  final String? teamId;
  final String roleName;
  final String eventName;
  final String? trackName;
  final String? teamName;
  final DateTime? assignedAt;

  EventRoleModel({
    required this.id,
    required this.userId,
    required this.eventId,
    this.trackId,
    this.teamId,
    required this.roleName,
    required this.eventName,
    this.trackName,
    this.teamName,
    this.assignedAt,
  });

  factory EventRoleModel.fromJson(Map<String, dynamic> json) => EventRoleModel(
        id: json['id']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        eventId: json['eventId']?.toString() ?? '',
        trackId: json['trackId']?.toString(),
        teamId: json['teamId']?.toString(),
        roleName: json['roleName']?.toString() ?? json['roleType']?.toString() ?? 'Student',
        eventName: json['eventName']?.toString() ?? json['event']?['name']?.toString() ?? '',
        trackName: json['trackName']?.toString() ?? json['track']?['name']?.toString(),
        teamName: json['teamName']?.toString() ?? json['team']?['name']?.toString(),
        assignedAt: json['assignedAt'] != null
            ? DateTime.tryParse(json['assignedAt'].toString())
            : null,
      );

  bool get isMentor => roleName.toLowerCase().contains('mentor');
  bool get isJudge => roleName.toLowerCase().contains('judge');
  bool get isStudent => roleName.toLowerCase().contains('student') || roleName.toLowerCase().contains('team');
  bool get isEC => roleName.toLowerCase().contains('coordinator') || roleName.toLowerCase().contains('ec');

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'eventId': eventId,
        'trackId': trackId,
        'teamId': teamId,
        'roleName': roleName,
        'eventName': eventName,
        'trackName': trackName,
        'teamName': teamName,
        'assignedAt': assignedAt?.toIso8601String(),
      };
}
