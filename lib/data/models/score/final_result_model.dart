class FinalResultModel {
  final String id;
  final String teamId;
  final String roundId;
  final String eventId;
  final String trackId;
  final String? prizeId;
  final double finalScore;
  final int rank;
  final bool isAdvanced;
  final bool isPublished;
  final DateTime? createdTime;

  FinalResultModel({
    required this.id,
    required this.teamId,
    required this.roundId,
    required this.eventId,
    required this.trackId,
    this.prizeId,
    required this.finalScore,
    required this.rank,
    required this.isAdvanced,
    required this.isPublished,
    this.createdTime,
  });

  factory FinalResultModel.fromJson(Map<String, dynamic> json) => FinalResultModel(
        id: json['id']?.toString() ?? '',
        teamId: json['teamId']?.toString() ?? '',
        roundId: json['roundId']?.toString() ?? '',
        eventId: json['eventId']?.toString() ?? '',
        trackId: json['trackId']?.toString() ?? '',
        prizeId: json['prizeId']?.toString(),
        finalScore: (json['finalScore'] as num?)?.toDouble() ?? (json['averageScore'] as num?)?.toDouble() ?? 0,
        rank: (json['rank'] as num?)?.toInt() ?? 0,
        isAdvanced: json['isAdvanced'] ?? false,
        isPublished: json['isPublished'] ?? true,
        createdTime: json['createdTime'] != null
            ? DateTime.tryParse(json['createdTime'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'teamId': teamId,
        'roundId': roundId,
        'eventId': eventId,
        'trackId': trackId,
        'prizeId': prizeId,
        'finalScore': finalScore,
        'rank': rank,
        'isAdvanced': isAdvanced,
        'isPublished': isPublished,
        'createdTime': createdTime?.toIso8601String(),
      };
}
