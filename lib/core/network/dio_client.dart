import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../constants/storage_keys.dart';
import '../../app/di/locator.dart';
import '../storage/secure_storage_service.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;
          final isPublicAuthEndpoint = path.endsWith(ApiEndpoints.login) ||
              path.endsWith(ApiEndpoints.googleLogin) ||
              path.endsWith(ApiEndpoints.register) ||
              path.endsWith(ApiEndpoints.forgotPassword) ||
              path.endsWith(ApiEndpoints.resetPassword);

          if (!isPublicAuthEndpoint) {
            final storage = locator<SecureStorageService>();
            final token = await storage.read(StorageKeys.accessToken);
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final path = error.requestOptions.path;
          final isAuthEndpoint = path.endsWith(ApiEndpoints.login) ||
              path.endsWith(ApiEndpoints.googleLogin) ||
              path.endsWith(ApiEndpoints.register) ||
              path.endsWith(ApiEndpoints.refreshToken) ||
              path.endsWith(ApiEndpoints.forgotPassword) ||
              path.endsWith(ApiEndpoints.resetPassword);

          if (error.response?.statusCode == 401 && !isAuthEndpoint) {
            final storage = locator<SecureStorageService>();
            final refreshToken = await storage.read(StorageKeys.refreshToken);

            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: ApiEndpoints.baseUrl,
                    connectTimeout: const Duration(seconds: 15),
                    receiveTimeout: const Duration(seconds: 15),
                  ),
                );
                final response = await refreshDio.post(
                  ApiEndpoints.refreshToken,
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  final data = response.data;
                  final newAccessToken = data['token'] ?? data['accessToken'];
                  final newRefreshToken = data['refreshToken'];

                  if (newAccessToken != null) {
                    await storage.write(StorageKeys.accessToken, newAccessToken);
                    if (newRefreshToken != null) {
                      await storage.write(StorageKeys.refreshToken, newRefreshToken);
                    }

                    final retryOptions = error.requestOptions;
                    retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                    final retryResponse = await _dio.fetch(retryOptions);
                    return handler.resolve(retryResponse);
                  }
                }
              } catch (e) {
                await storage.delete(StorageKeys.accessToken);
                await storage.delete(StorageKeys.refreshToken);
              }
            }
          }

          // Retry mechanism for transient connection timeouts
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError) {
            final retryCount = (error.requestOptions.extra['retry_count'] as int? ?? 0);
            if (retryCount < 2) {
              error.requestOptions.extra['retry_count'] = retryCount + 1;
              await Future.delayed(Duration(milliseconds: 1000 * (retryCount + 1)));
              try {
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (_) {
                // Fallthrough to handler.next if retry fails
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
