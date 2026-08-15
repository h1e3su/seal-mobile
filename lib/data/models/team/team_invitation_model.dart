class TeamInvitationModel {
  final String id;
  final String teamId;
  final String teamName;
  final String? eventId;
  final String? eventName;
  final String? invitedUserId;
  final String? invitedUserEmail;
  final String? invitedByUserName;
  final String status;
  final DateTime? createdDate;

  const TeamInvitationModel({
    required this.id,
    required this.teamId,
    required this.teamName,
    this.eventId,
    this.eventName,
    this.invitedUserId,
    this.invitedUserEmail,
    this.invitedByUserName,
    this.status = 'Pending',
    this.createdDate,
  });

  bool get isPending => status.toLowerCase() == 'pending';

  factory TeamInvitationModel.fromJson(Map<String, dynamic> json) {
    return TeamInvitationModel(
      id: (json['id'] ?? json['invitationId'] ?? '').toString(),
      teamId: (json['teamId'] ?? '').toString(),
      teamName: (json['teamName'] ?? 'Đội thi').toString(),
      eventId: json['eventId']?.toString(),
      eventName: json['eventName']?.toString(),
      invitedUserId: json['invitedUserId']?.toString(),
      invitedUserEmail: json['invitedUserEmail']?.toString() ?? json['email']?.toString(),
      invitedByUserName: json['invitedByUserName']?.toString() ?? json['invitedBy']?.toString(),
      status: (json['status'] ?? 'Pending').toString(),
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'].toString())
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'teamId': teamId,
      'teamName': teamName,
      'eventId': eventId,
      'eventName': eventName,
      'invitedUserId': invitedUserId,
      'invitedUserEmail': invitedUserEmail,
      'invitedByUserName': invitedByUserName,
      'status': status,
      'createdDate': createdDate?.toIso8601String(),
    };
  }
}
