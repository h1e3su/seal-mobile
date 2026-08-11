import 'package:dio/dio.dart';

class ErrorMapper {
  static String toMessage(Exception exception) {
    if (exception is DioException) {
      final data = exception.response?.data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Kết nối quá thời gian. Vui lòng thử lại.';
        case DioExceptionType.connectionError:
          return 'Không thể kết nối máy chủ. Kiểm tra mạng.';
        default:
          return 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      }
    }
    return 'Đã có lỗi xảy ra. Vui lòng thử lại.';
  }
}
