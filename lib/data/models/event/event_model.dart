class EventModel {
  final String id;
  final String title;
  final String description;
  final String? bannerUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? registrationStartDate;
  final DateTime? registrationEndDate;
  final String? location;
  final String status;
  final int totalTeams;
  final int maxTeams;
  final String? season;
  final int? year;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.bannerUrl,
    this.startDate,
    this.endDate,
    this.registrationStartDate,
    this.registrationEndDate,
    this.location,
    this.status = 'RegistrationOpen',
    this.totalTeams = 0,
    this.maxTeams = 0,
    this.season,
    this.year,
  });

  String get name => title;

  bool get isOpen {
    final now = DateTime.now();

    // 1. Kiểm tra status dạng text/boolean
    final st = status.trim().toLowerCase();
    if (st == 'false' ||
        st == '0' ||
        st == 'closed' ||
        st == 'ended' ||
        st == 'inactive' ||
        st == 'cancelled') {
      return false;
    }

    // 2. Nếu đã quá ngày kết thúc -> Đã đóng
    if (endDate != null && now.isAfter(endDate!)) {
      return false;
    }

    // 3. Nếu còn trong thời gian đăng ký hoặc thời gian diễn ra
    if (registrationEndDate != null && now.isBefore(registrationEndDate!)) {
      return true;
    }

    if (endDate != null && now.isBefore(endDate!)) {
      return true;
    }

    // 4. Kiểm tra các keyword status mở
    if (st == 'true' ||
        st == '1' ||
        st == 'registrationopen' ||
        st == 'ongoing' ||
        st == 'open' ||
        st == 'active' ||
        st.isEmpty) {
      return true;
    }

    return true;
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: (json['id'] ?? json['eventId'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? json['eventName'] ?? 'Sự kiện').toString(),
      description: (json['description'] ?? '').toString(),
      bannerUrl: json['bannerUrl']?.toString() ?? json['imageUrl']?.toString() ?? json['photoEventUrl']?.toString(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate'].toString()) : null,
      registrationStartDate: json['registrationStartDate'] != null ? DateTime.tryParse(json['registrationStartDate'].toString()) : null,
      registrationEndDate: json['registrationEndDate'] != null ? DateTime.tryParse(json['registrationEndDate'].toString()) : null,
      location: json['location']?.toString(),
      status: (json['status'] ?? 'RegistrationOpen').toString(),
      totalTeams: (json['totalTeams'] as num?)?.toInt() ?? (json['teamCount'] as num?)?.toInt() ?? 0,
      maxTeams: (json['maxTeams'] as num?)?.toInt() ?? 0,
      season: json['season']?.toString(),
      year: (json['year'] as num?)?.toInt(),
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
      'registrationStartDate': registrationStartDate?.toIso8601String(),
      'registrationEndDate': registrationEndDate?.toIso8601String(),
      'location': location,
      'status': status,
      'totalTeams': totalTeams,
      'maxTeams': maxTeams,
      'season': season,
      'year': year,
    };
  }
}
