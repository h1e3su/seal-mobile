class ResponseParser {
  /// Safely extracts a List from any nested API response structure
  static List<dynamic> extractList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      // Check first-level keys
      final candidate = data['data'] ?? data['items'] ?? data['results'] ?? data['result'];
      if (candidate is List) return candidate;

      // Check second-level keys if candidate is a Map
      if (candidate is Map<String, dynamic>) {
        final inner = candidate['data'] ?? candidate['items'] ?? candidate['results'] ?? candidate['result'];
        if (inner is List) return inner;
      }
    }

    return [];
  }

  /// Safely extracts a Map/Object from any nested API response structure
  static Map<String, dynamic>? extractMap(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      if (data['result'] is Map<String, dynamic>) {
        return data['result'] as Map<String, dynamic>;
      }
      return data;
    }
    return null;
  }
}
