class AppealModel {
  final String id;
  final String teamId;
  final String? teamName;
  final String roundId;
  final String? roundName;
  final String reason;
  final String? evidenceUrl;
  final String status; // Pending, Accepted, Rejected
  final String? responseComment;
  final DateTime? createdDate;

  const AppealModel({
    required this.id,
    required this.teamId,
    this.teamName,
    required this.roundId,
    this.roundName,
    required this.reason,
    this.evidenceUrl,
    this.status = 'Pending',
    this.responseComment,
    this.createdDate,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isAccepted => status.toLowerCase() == 'accepted' || status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';

  factory AppealModel.fromJson(Map<String, dynamic> json) {
    return AppealModel(
      id: (json['id'] ?? json['appealId'] ?? '').toString(),
      teamId: (json['teamId'] ?? '').toString(),
      teamName: json['teamName']?.toString(),
      roundId: (json['roundId'] ?? '').toString(),
      roundName: json['roundName']?.toString(),
      reason: (json['reason'] ?? '').toString(),
      evidenceUrl: json['evidenceUrl']?.toString(),
      status: (json['status'] ?? 'Pending').toString(),
      responseComment: json['responseComment']?.toString() ?? json['comment']?.toString(),
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
      'roundId': roundId,
      'roundName': roundName,
      'reason': reason,
      'evidenceUrl': evidenceUrl,
      'status': status,
      'responseComment': responseComment,
      'createdDate': createdDate?.toIso8601String(),
    };
  }
}
