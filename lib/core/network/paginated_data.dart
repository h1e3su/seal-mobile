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
    if (json is List) {
      final items = json
          .whereType<Map<String, dynamic>>()
          .map((item) => fromJsonT(item))
          .toList();
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

    if (json is Map<String, dynamic>) {
      final rawList = json['data'] as List? ?? json['items'] as List? ?? [];
      final items = rawList
          .whereType<Map<String, dynamic>>()
          .map((item) => fromJsonT(item))
          .toList();

      final currentPageVal = (json['currentPage'] as num?)?.toInt() ?? (json['pageNumber'] as num?)?.toInt() ?? 1;
      final pageSizeVal = (json['pageSize'] as num?)?.toInt() ?? items.length;
      final totalItemsVal = (json['totalItems'] as num?)?.toInt() ?? (json['totalCount'] as num?)?.toInt() ?? items.length;
      final totalPagesVal = (json['totalPages'] as num?)?.toInt() ?? 1;

      return PaginatedData<T>(
        data: items,
        currentPage: currentPageVal,
        pageSize: pageSizeVal,
        totalItems: totalItemsVal,
        totalPages: totalPagesVal,
        hasPreviousPage: json['hasPreviousPage'] ?? (currentPageVal > 1),
        hasNextPage: json['hasNextPage'] ?? (currentPageVal < totalPagesVal),
      );
    }

    return PaginatedData<T>(data: const []);
  }
}
