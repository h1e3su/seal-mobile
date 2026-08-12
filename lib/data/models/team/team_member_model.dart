class TeamMemberModel {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String role; // Leader, Member
  final bool isAccepted;

  const TeamMemberModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.role = 'Member',
    this.isAccepted = true,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['user']?['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['user']?['fullName']?.toString() ?? 'Thành viên',
      email: json['email']?.toString() ?? json['user']?['email']?.toString() ?? '',
      role: json['role']?.toString() ?? json['roleType']?.toString() ?? 'Member',
      isAccepted: json['isAccepted'] ?? json['status'] == 'Accepted' ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'role': role,
      'isAccepted': isAccepted,
    };
  }
}
