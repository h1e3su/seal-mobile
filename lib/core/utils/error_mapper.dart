import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorMapper {
  static String toMessage(Exception exception) {
    debugPrint('=== NETWORK ERROR ===');
    debugPrint('Exception: ${exception.runtimeType}');
    debugPrint('Details: $exception');
    if (exception is DioException) {
      debugPrint('Path: ${exception.requestOptions.path}');
      debugPrint('Method: ${exception.requestOptions.method}');
      debugPrint('Status Code: ${exception.response?.statusCode}');
      debugPrint('Response Body: ${exception.response?.data}');
      debugPrint('Type: ${exception.type}');
      debugPrint('Error: ${exception.error}');
    }
    debugPrint('======================');

    if (exception is DioException) {
      final data = exception.response?.data;
      if (data is Map) {
        // 1. Check validation errors dictionary
        if (data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          for (final value in errorsMap.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            if (value is String && value.isNotEmpty) {
              return value;
            }
          }
        }

        // 2. Check direct message
        if (data['message'] is String && (data['message'] as String).isNotEmpty) {
          final msg = data['message'] as String;
          if (!msg.contains('SEAL_Domain.Base.BaseException')) {
            return msg;
          }
        }

        // 3. Check detail
        if (data['detail'] is String && (data['detail'] as String).isNotEmpty) {
          final detail = data['detail'] as String;
          if (!detail.contains('SEAL_Domain.Base.BaseException')) {
            return detail;
          }
        }

        // 4. Check title
        if (data['title'] is String && (data['title'] as String).isNotEmpty) {
          return data['title'] as String;
        }
      }

      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Kết nối quá thời gian. Vui lòng thử lại.';
        case DioExceptionType.connectionError:
          return 'Không thể kết nối máy chủ. Kiểm tra mạng.';
        default:
          return 'Yêu cầu không hợp lệ hoặc thông tin chưa đầy đủ.';
      }
    }
    final msg = exception.toString().replaceFirst('Exception: ', '').trim();
    return msg.isNotEmpty ? msg : 'Đã có lỗi xảy ra. Vui lòng thử lại.';
  }
}
