class CriteriaScoreModel {
  final String criteriaName;
  final double value;
  final double maxScore;
  final double weight;

  CriteriaScoreModel({
    required this.criteriaName,
    required this.value,
    required this.maxScore,
    required this.weight,
  });

  factory CriteriaScoreModel.fromJson(Map<String, dynamic> json) => CriteriaScoreModel(
        criteriaName: json['criteriaName']?.toString() ?? json['name']?.toString() ?? 'Tiêu chí',
        value: (json['value'] as num?)?.toDouble() ?? (json['score'] as num?)?.toDouble() ?? 0,
        maxScore: (json['maxScore'] as num?)?.toDouble() ?? 10.0,
        weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      );

  Map<String, dynamic> toJson() => {
        'criteriaName': criteriaName,
        'value': value,
        'maxScore': maxScore,
        'weight': weight,
      };
}
