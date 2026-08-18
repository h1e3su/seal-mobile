class ApiResponse<T> {
  final T data;
  final String? message;
  final dynamic statusCode;
  final bool success;

  ApiResponse({
    required this.data,
    this.message,
    this.statusCode = 200,
    required this.success,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final rawData = json['data'] ?? json;
    return ApiResponse(
      data: fromJsonT(rawData),
      message: json['message']?.toString(),
      statusCode: json['statusCode'] ?? 200,
      success: json['success'] == true ||
          json['success'] == 'true' ||
          json['statusCode'] == 'OK' ||
          json['statusCode'] == 200,
    );
  }
}
