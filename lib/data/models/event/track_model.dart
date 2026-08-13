class TrackModel {
  final String id;
  final String name;
  final String? description;
  final String? roundId;
  final String? roundName;
  final String? templateId;
  final String? startDate;
  final String? endDate;
  final List<String> judges;
  final List<String> mentors;

  const TrackModel({
    required this.id,
    required this.name,
    this.description,
    this.roundId,
    this.roundName,
    this.templateId,
    this.startDate,
    this.endDate,
    this.judges = const [],
    this.mentors = const [],
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    List<String> parseUserList(dynamic raw) {
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return item['fullName']?.toString() ?? item['userName']?.toString() ?? item['id']?.toString() ?? '';
          }
          return item.toString();
        }).where((name) => name.isNotEmpty).toList();
      }
      return [];
    }

    return TrackModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Hạng mục',
      description: json['description']?.toString(),
      roundId: json['roundId']?.toString(),
      roundName: json['roundName']?.toString() ?? json['round']?['name']?.toString(),
      templateId: json['templateId']?.toString(),
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      judges: parseUserList(json['judges']),
      mentors: parseUserList(json['mentors']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'roundId': roundId,
      'roundName': roundName,
      'templateId': templateId,
      'startDate': startDate,
      'endDate': endDate,
      'judges': judges,
      'mentors': mentors,
    };
  }
}
