import 'submission_score_model.dart';

class ScoreBreakdownModel {
  final String teamId;
  final String teamName;
  final List<SubmissionScoreModel> submissions;

  ScoreBreakdownModel({
    required this.teamId,
    required this.teamName,
    required this.submissions,
  });

  factory ScoreBreakdownModel.fromJson(Map<String, dynamic> json) => ScoreBreakdownModel(
        teamId: json['teamId']?.toString() ?? '',
        teamName: json['teamName']?.toString() ?? 'Đội thi',
        submissions: (json['submissions'] as List<dynamic>? ?? [])
            .map((e) => SubmissionScoreModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'teamId': teamId,
        'teamName': teamName,
        'submissions': submissions.map((e) => e.toJson()).toList(),
      };
}
