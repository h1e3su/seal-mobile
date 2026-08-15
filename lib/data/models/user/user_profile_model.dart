class UserProfileModel {
  final String id;
  final String? schoolId;
  final String? schoolName;
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
    this.schoolName,
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

  String? get studentCardImageUrl => photoStudentCardUrl;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['registrationStatus'] ??
            json['status'] ??
            json['userStatus'] ??
            json['studentStatus'] ??
            '')
        .toString()
        .trim()
        .toLowerCase();

    final bool approved = json['isApproved'] == true ||
        json['isApproved'] == 'true' ||
        json['isApproved'] == 1 ||
        rawStatus == 'approved' ||
        rawStatus == 'active' ||
        rawStatus == 'verified';

    final bool rejected = json['isRejected'] == true ||
        json['isRejected'] == 'true' ||
        json['isRejected'] == 1 ||
        rawStatus == 'rejected';

    final String emailStr = (json['email'] ?? '').toString();
    final String? studentCodeStr = json['studentCode']?.toString();

    final bool fpt = json['isFpt'] == true ||
        json['isFpt'] == 'true' ||
        emailStr.toLowerCase().endsWith('@fpt.edu.vn') ||
        (studentCodeStr != null &&
            studentCodeStr.isNotEmpty &&
            RegExp(r'^(SE|SS|SA|SB|IA|GD|MC|DS)\d+', caseSensitive: false)
                .hasMatch(studentCodeStr));

    final bool student = json['isStudent'] == true ||
        json['isStudent'] == 'true' ||
        json['isStudent'] == 1 ||
        (studentCodeStr != null && studentCodeStr.isNotEmpty);

    return UserProfileModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      schoolId: json['schoolId']?.toString(),
      schoolName: json['schoolName']?.toString() ?? json['school']?['name']?.toString(),
      studentCode: studentCodeStr,
      email: emailStr,
      fullName: (json['fullName'] ?? json['name'] ?? json['userName'] ?? '').toString(),
      isStudent: student,
      isAdmin: json['isAdmin'] == true || json['isAdmin'] == 'true' || json['isAdmin'] == 1,
      isApproved: approved,
      isFpt: fpt,
      isRejected: rejected,
      isTemporary: json['isTemporary'] == true || json['isTemporary'] == 'true' || json['isTemporary'] == 1,
      photoStudentCardUrl: json['photoStudentCardUrl']?.toString() ?? json['studentCardImageUrl']?.toString(),
    );
  }

  bool get isPending => !isApproved && !isRejected;

  String get registrationStatus {
    if (isApproved) return 'Approved';
    if (isRejected) return 'Rejected';
    return 'Pending';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'schoolId': schoolId,
      'schoolName': schoolName,
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
      'studentCardImageUrl': photoStudentCardUrl,
    };
  }
}
