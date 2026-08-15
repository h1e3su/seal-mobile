class UserRejectionModel {
  final String id;
  final String? userId;
  final String reason;
  final DateTime? rejectedAt;

  const UserRejectionModel({
    required this.id,
    this.userId,
    required this.reason,
    this.rejectedAt,
  });

  factory UserRejectionModel.fromJson(Map<String, dynamic> json) {
    return UserRejectionModel(
      id: (json['id'] ?? json['rejectionId'] ?? '').toString(),
      userId: json['userId']?.toString(),
      reason: (json['reason'] ?? json['rejectReason'] ?? json['description'] ?? 'Hồ sơ chưa đạt yêu cầu').toString(),
      rejectedAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : (json['rejectedAt'] != null ? DateTime.tryParse(json['rejectedAt'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'reason': reason,
      'createdAt': rejectedAt?.toIso8601String(),
    };
  }
}
