import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class StorageRemoteDataSource {
  final DioClient _dioClient;

  const StorageRemoteDataSource(this._dioClient);

  Future<String> uploadFile(File file, {String folder = 'general'}) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await _dioClient.dio.post(
      ApiEndpoints.uploadFile,
      queryParameters: {'folder': folder},
      data: formData,
    );

    if (response.data != null) {
      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        if (resData['data'] is Map<String, dynamic>) {
          final map = resData['data'] as Map<String, dynamic>;
          return (map['fileUrl'] ?? map['url'] ?? map['imageUrl'] ?? '').toString();
        } else if (resData['data'] is String) {
          return resData['data'] as String;
        } else if (resData['fileUrl'] != null) {
          return resData['fileUrl'].toString();
        }
      } else if (resData is String) {
        return resData;
      }
    }
    return '';
  }

  Future<String> uploadFileBytes(List<int> bytes, String fileName, {String folder = 'general'}) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final response = await _dioClient.dio.post(
      ApiEndpoints.uploadFile,
      queryParameters: {'folder': folder},
      data: formData,
    );

    if (response.data != null) {
      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        if (resData['data'] is Map<String, dynamic>) {
          final map = resData['data'] as Map<String, dynamic>;
          return (map['fileUrl'] ?? map['url'] ?? map['imageUrl'] ?? '').toString();
        } else if (resData['data'] is String) {
          return resData['data'] as String;
        } else if (resData['fileUrl'] != null) {
          return resData['fileUrl'].toString();
        }
      } else if (resData is String) {
        return resData;
      }
    }
    return '';
  }
}
