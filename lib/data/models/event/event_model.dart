class EventModel {
  final String id;
  final String title;
  final String description;
  final String? bannerUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? location;
  final String status;
  final int totalTeams;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.bannerUrl,
    this.startDate,
    this.endDate,
    this.location,
    this.status = 'RegistrationOpen',
    this.totalTeams = 0,
  });

  String get name => title;

  bool get isOpen =>
      status == 'RegistrationOpen' ||
      status == 'Ongoing' ||
      status == 'OPEN' ||
      status == 'Active';

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: (json['id'] ?? json['eventId'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? json['eventName'] ?? 'Sự kiện').toString(),
      description: (json['description'] ?? '').toString(),
      bannerUrl: json['bannerUrl']?.toString() ?? json['imageUrl']?.toString(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'].toString()) : null,
      location: json['location']?.toString(),
      status: (json['status'] ?? 'RegistrationOpen').toString(),
      totalTeams: (json['totalTeams'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'name': title,
      'description': description,
      'bannerUrl': bannerUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'location': location,
      'status': status,
      'totalTeams': totalTeams,
    };
  }
}
