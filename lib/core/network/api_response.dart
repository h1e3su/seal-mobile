class ApiResponse<T> {
  final T data;
  final String? message;
  final int statusCode;
  final bool success;

  ApiResponse({
    required this.data,
    this.message,
    required this.statusCode,
    required this.success,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      message: json['message'],
      statusCode: json['statusCode'] ?? 200,
      success: json['success'] ?? true,
    );
  }
}
