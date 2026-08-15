class SubmitResultModel {
  final String id;
  final String teamId;
  final String? teamName;
  final String trackId;
  final String? trackName;
  final String title;
  final String? description;
  final String submissionUrl;
  final String? attachmentUrl;
  final DateTime? submittedAt;
  final String status;
  final double? finalScore;

  const SubmitResultModel({
    required this.id,
    required this.teamId,
    this.teamName,
    required this.trackId,
    this.trackName,
    required this.title,
    this.description,
    required this.submissionUrl,
    this.attachmentUrl,
    this.submittedAt,
    this.status = 'Submitted',
    this.finalScore,
  });

  bool get isGraded => status.toLowerCase() == 'graded' || finalScore != null;

  factory SubmitResultModel.fromJson(Map<String, dynamic> json) {
    return SubmitResultModel(
      id: (json['id'] ?? json['submitResultId'] ?? '').toString(),
      teamId: (json['teamId'] ?? '').toString(),
      teamName: json['teamName']?.toString(),
      trackId: (json['trackId'] ?? '').toString(),
      trackName: json['trackName']?.toString(),
      title: (json['title'] ?? json['projectName'] ?? 'Bài dự thi').toString(),
      description: json['description']?.toString(),
      submissionUrl: (json['submissionUrl'] ?? json['projectUrl'] ?? json['url'] ?? '').toString(),
      attachmentUrl: json['attachmentUrl']?.toString() ?? json['fileUrl']?.toString(),
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'].toString())
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
      status: (json['status'] ?? 'Submitted').toString(),
      finalScore: (json['finalScore'] as num?)?.toDouble() ?? (json['totalScore'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'teamId': teamId,
      'teamName': teamName,
      'trackId': trackId,
      'trackName': trackName,
      'title': title,
      'description': description,
      'submissionUrl': submissionUrl,
      'attachmentUrl': attachmentUrl,
      'submittedAt': submittedAt?.toIso8601String(),
      'status': status,
      'finalScore': finalScore,
    };
  }
}
