import 'criteria_score_model.dart';

class JudgeScoreModel {
  final String judgeName;
  final double totalScore;
  final String? comment;
  final bool isSubmitted;
  final List<CriteriaScoreModel> criteria;

  JudgeScoreModel({
    required this.judgeName,
    required this.totalScore,
    this.comment,
    required this.isSubmitted,
    required this.criteria,
  });

  factory JudgeScoreModel.fromJson(Map<String, dynamic> json) => JudgeScoreModel(
        judgeName: json['judgeName']?.toString() ?? 'Giám khảo',
        totalScore: (json['totalScore'] as num?)?.toDouble() ?? (json['score'] as num?)?.toDouble() ?? 0,
        comment: json['comment']?.toString(),
        isSubmitted: json['isSubmitted'] ?? false,
        criteria: (json['criteria'] as List<dynamic>? ?? json['criteriaScores'] as List<dynamic>? ?? [])
            .map((e) => CriteriaScoreModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'judgeName': judgeName,
        'totalScore': totalScore,
        'comment': comment,
        'isSubmitted': isSubmitted,
        'criteria': criteria.map((e) => e.toJson()).toList(),
      };
}
