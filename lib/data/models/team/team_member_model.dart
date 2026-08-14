class TeamMemberModel {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String role; // TeamLeader, TeamMember, Member, Leader
  final String registrationStatus; // Approved, Pending, Rejected, Unregistered
  final String? studentCode;
  final String? avatarUrl;
  final bool isAccepted;

  const TeamMemberModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.role = 'TeamMember',
    this.registrationStatus = 'Approved',
    this.studentCode,
    this.avatarUrl,
    this.isAccepted = true,
  });

  bool get isLeader =>
      role.toLowerCase() == 'leader' ||
      role.toLowerCase() == 'teamleader';

  bool get isVerified =>
      registrationStatus.toLowerCase() == 'approved';

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    final rawRegStatus = json['registrationStatus']?.toString() ??
        (json['isVerified'] == true ? 'Approved' : (json['isVerified'] == false ? 'Pending' : 'Approved'));

    return TeamMemberModel(
      id: (json['id'] ?? json['memberId'] ?? '').toString(),
      userId: (json['userId'] ?? json['user']?['id'] ?? json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? json['user']?['fullName'] ?? json['name'] ?? 'Thành viên').toString(),
      email: (json['email'] ?? json['user']?['email'] ?? '').toString(),
      role: (json['roleInTeam'] ?? json['role'] ?? json['roleType'] ?? 'TeamMember').toString(),
      registrationStatus: rawRegStatus,
      studentCode: json['studentCode']?.toString() ?? json['user']?['studentCode']?.toString(),
      avatarUrl: json['avatarUrl']?.toString() ?? json['user']?['avatarUrl']?.toString(),
      isAccepted: json['isAccepted'] ?? json['status'] == 'Accepted' ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'roleInTeam': role,
      'registrationStatus': registrationStatus,
      'studentCode': studentCode,
      'avatarUrl': avatarUrl,
      'isAccepted': isAccepted,
    };
  }
}
