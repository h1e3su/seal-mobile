class CriteriaItemModel {
  final String id;
  final String name;
  final String? description;
  final double maxScore;
  final double weight;

  const CriteriaItemModel({
    required this.id,
    required this.name,
    this.description,
    this.maxScore = 10.0,
    this.weight = 1.0,
  });

  factory CriteriaItemModel.fromJson(Map<String, dynamic> json) {
    return CriteriaItemModel(
      id: (json['id'] ?? json['criteriaId'] ?? '').toString(),
      name: (json['name'] ?? json['criteriaName'] ?? '').toString(),
      description: json['description']?.toString(),
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 10.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'maxScore': maxScore,
      'weight': weight,
    };
  }
}

class TemplateModel {
  final String id;
  final String name;
  final String? description;
  final List<CriteriaItemModel> criteria;

  const TemplateModel({
    required this.id,
    required this.name,
    this.description,
    this.criteria = const [],
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['criteria'] as List? ?? json['criteriaList'] as List? ?? [];
    return TemplateModel(
      id: (json['id'] ?? json['templateId'] ?? '').toString(),
      name: (json['name'] ?? json['templateName'] ?? 'Bộ tiêu chí').toString(),
      description: json['description']?.toString(),
      criteria: rawList
          .whereType<Map<String, dynamic>>()
          .map((c) => CriteriaItemModel.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'criteria': criteria.map((c) => c.toJson()).toList(),
    };
  }
}
