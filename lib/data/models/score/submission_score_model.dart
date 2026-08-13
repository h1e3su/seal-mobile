import 'judge_score_model.dart';

class SubmissionScoreModel {
  final String submitResultId;
  final String trackName;
  final String roundId;
  final String roundName;
  final bool roundPublished;
  final List<JudgeScoreModel> judgeScores;

  SubmissionScoreModel({
    required this.submitResultId,
    required this.trackName,
    required this.roundId,
    required this.roundName,
    required this.roundPublished,
    required this.judgeScores,
  });

  factory SubmissionScoreModel.fromJson(Map<String, dynamic> json) => SubmissionScoreModel(
        submitResultId: json['submitResultId']?.toString() ?? json['id']?.toString() ?? '',
        trackName: json['trackName']?.toString() ?? 'Hạng mục',
        roundId: json['roundId']?.toString() ?? '',
        roundName: json['roundName']?.toString() ?? 'Vòng thi',
        roundPublished: json['roundPublished'] ?? json['isPublished'] ?? false,
        judgeScores: (json['judgeScores'] as List<dynamic>? ?? json['scores'] as List<dynamic>? ?? [])
            .map((e) => JudgeScoreModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'submitResultId': submitResultId,
        'trackName': trackName,
        'roundId': roundId,
        'roundName': roundName,
        'roundPublished': roundPublished,
        'judgeScores': judgeScores.map((e) => e.toJson()).toList(),
      };
}
