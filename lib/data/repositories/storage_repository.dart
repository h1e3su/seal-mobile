import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../services/storage_remote_datasource.dart';

class StorageRepository {
  final StorageRemoteDataSource _remoteDataSource;

  const StorageRepository(this._remoteDataSource);

  Future<ApiResult<String>> uploadFile(File file, {String folder = 'general'}) async {
    try {
      final url = await _remoteDataSource.uploadFile(file, folder: folder);
      return Success(url);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<ApiResult<String>> uploadFileBytes(List<int> bytes, String fileName, {String folder = 'general'}) async {
    try {
      final url = await _remoteDataSource.uploadFileBytes(bytes, fileName, folder: folder);
      return Success(url);
    } on DioException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
