class RoundModel {
  final String id;
  final String eventId;
  final String roundName;
  final int order;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? advancementRule;

  const RoundModel({
    required this.id,
    required this.eventId,
    required this.roundName,
    this.order = 1,
    this.startDate,
    this.endDate,
    this.advancementRule,
  });

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      id: (json['id'] ?? json['roundId'] ?? '').toString(),
      eventId: (json['eventId'] ?? '').toString(),
      roundName: (json['roundName'] ?? json['name'] ?? 'Vòng thi').toString(),
      order: (json['order'] as num?)?.toInt() ?? 1,
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'].toString()) : null,
      advancementRule: json['advancementRule']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'roundName': roundName,
      'order': order,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'advancementRule': advancementRule,
    };
  }
}
