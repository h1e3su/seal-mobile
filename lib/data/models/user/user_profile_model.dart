class UserProfileModel {
  final String id;
  final String? schoolId;
  final String? studentCode;
  final String email;
  final String fullName;
  final bool isStudent;
  final bool isAdmin;
  final bool isApproved;
  final bool isFpt;
  final bool isRejected;
  final bool isTemporary;
  final String? photoStudentCardUrl;

  UserProfileModel({
    required this.id,
    this.schoolId,
    this.studentCode,
    required this.email,
    required this.fullName,
    required this.isStudent,
    required this.isAdmin,
    required this.isApproved,
    required this.isFpt,
    required this.isRejected,
    required this.isTemporary,
    this.photoStudentCardUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      schoolId: json['schoolId'],
      studentCode: json['studentCode'],
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      isStudent: json['isStudent'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      isApproved: json['isApproved'] ?? false,
      isFpt: json['isFpt'] ?? false,
      isRejected: json['isRejected'] ?? false,
      isTemporary: json['isTemporary'] ?? false,
      photoStudentCardUrl: json['photoStudentCardUrl'],
    );
  }

  bool get isPending => !isApproved && !isRejected;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'schoolId': schoolId,
      'studentCode': studentCode,
      'email': email,
      'fullName': fullName,
      'isStudent': isStudent,
      'isAdmin': isAdmin,
      'isApproved': isApproved,
      'isFpt': isFpt,
      'isRejected': isRejected,
      'isTemporary': isTemporary,
      'photoStudentCardUrl': photoStudentCardUrl,
    };
  }
}
