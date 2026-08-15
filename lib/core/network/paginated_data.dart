import '../utils/response_parser.dart';

class PaginatedData<T> {
  final List<T> data;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedData({
    required this.data,
    this.currentPage = 1,
    this.pageSize = 50,
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasPreviousPage = false,
    this.hasNextPage = false,
  });

  factory PaginatedData.fromJson(
    dynamic json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    if (json == null) return PaginatedData<T>(data: const []);

    final rawList = ResponseParser.extractList(json);
    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => fromJsonT(item))
        .toList();

    if (json is Map<String, dynamic>) {
      final container = json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : (json['result'] is Map<String, dynamic>
              ? json['result'] as Map<String, dynamic>
              : json);

      final currentPageVal = (container['currentPage'] as num?)?.toInt() ??
          (container['pageNumber'] as num?)?.toInt() ??
          (json['currentPage'] as num?)?.toInt() ??
          1;
      final pageSizeVal = (container['pageSize'] as num?)?.toInt() ??
          (json['pageSize'] as num?)?.toInt() ??
          (items.isNotEmpty ? items.length : 20);
      final totalItemsVal = (container['totalItems'] as num?)?.toInt() ??
          (container['totalCount'] as num?)?.toInt() ??
          (json['totalItems'] as num?)?.toInt() ??
          items.length;
      final totalPagesVal = (container['totalPages'] as num?)?.toInt() ??
          (json['totalPages'] as num?)?.toInt() ??
          1;

      return PaginatedData<T>(
        data: items,
        currentPage: currentPageVal,
        pageSize: pageSizeVal,
        totalItems: totalItemsVal,
        totalPages: totalPagesVal,
        hasPreviousPage: container['hasPreviousPage'] ?? json['hasPreviousPage'] ?? (currentPageVal > 1),
        hasNextPage: container['hasNextPage'] ?? json['hasNextPage'] ?? (currentPageVal < totalPagesVal),
      );
    }

    return PaginatedData<T>(
      data: items,
      currentPage: 1,
      pageSize: items.length,
      totalItems: items.length,
      totalPages: 1,
      hasPreviousPage: false,
      hasNextPage: false,
    );
  }
}
