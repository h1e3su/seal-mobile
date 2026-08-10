import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../../app/di/locator.dart';
import '../storage/secure_storage_service.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = locator<SecureStorageService>();
          final token = await storage.read('access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != ApiEndpoints.login &&
              error.requestOptions.path != ApiEndpoints.refreshToken) {
            
            final storage = locator<SecureStorageService>();
            final refreshToken = await storage.read('refresh_token');

            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
                final response = await refreshDio.post(
                  ApiEndpoints.refreshToken,
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  final data = response.data;
                  final newAccessToken = data['token'] ?? data['accessToken'];
                  final newRefreshToken = data['refreshToken'];

                  if (newAccessToken != null) {
                    await storage.write('access_token', newAccessToken);
                    if (newRefreshToken != null) {
                      await storage.write('refresh_token', newRefreshToken);
                    }

                    final retryOptions = error.requestOptions;
                    retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                    final retryResponse = await _dio.fetch(retryOptions);
                    return handler.resolve(retryResponse);
                  }
                }
              } catch (e) {
                await storage.delete('access_token');
                await storage.delete('refresh_token');
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
