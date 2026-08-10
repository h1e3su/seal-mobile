import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../ui/auth/viewmodels/login_viewmodel.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<DioClient>(() => DioClient());
  locator.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(locator<DioClient>()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(locator<AuthRemoteDataSource>()));

  // ViewModels
  locator.registerFactory<LoginViewModel>(() => LoginViewModel(locator<AuthRepository>()));
}
