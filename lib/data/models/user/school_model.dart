class SchoolModel {
  final String id;
  final String name;
  final String? code;
  final String? address;
  final int userCount;

  const SchoolModel({
    required this.id,
    required this.name,
    this.code,
    this.address,
    this.userCount = 0,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: (json['id'] ?? json['schoolId'] ?? '').toString(),
      name: (json['schoolName'] ?? json['name'] ?? '').toString(),
      code: json['code']?.toString(),
      address: json['address']?.toString(),
      userCount: (json['userCount'] as num?)?.toInt() ?? (json['studentCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'userCount': userCount,
    };
  }
}

class FptStudentMockModel {
  final String studentCode;
  final String fullName;
  final String major;
  final String batch;
  final String? email;
  final bool isValid;
  final int? enrollYear;

  const FptStudentMockModel({
    required this.studentCode,
    required this.fullName,
    required this.major,
    this.batch = '',
    this.email,
    this.isValid = true,
    this.enrollYear,
  });

  factory FptStudentMockModel.fromJson(Map<String, dynamic> json) {
    return FptStudentMockModel(
      studentCode: (json['studentCode'] ?? '').toString(),
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
      major: (json['major'] ?? json['specialization'] ?? '').toString(),
      batch: (json['batch'] ?? json['cohort'] ?? json['enrollYear']?.toString() ?? '').toString(),
      email: json['email']?.toString(),
      isValid: json['isValid'] as bool? ?? true,
      enrollYear: (json['enrollYear'] as num?)?.toInt(),
    );
  }
}
