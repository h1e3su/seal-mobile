import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/secure_storage_service.dart';

// Data Sources
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/event_remote_datasource.dart';
import '../../data/datasources/team_remote_datasource.dart';
import '../../data/datasources/submit_result_remote_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/datasources/event_role_remote_datasource.dart';
import '../../data/datasources/storage_remote_datasource.dart';
import '../../data/datasources/track_remote_datasource.dart';

// Repositories
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/team_repository.dart';
import '../../data/repositories/submission_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/event_role_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/track_repository.dart';

// ViewModels
import '../../ui/auth/viewmodels/login_viewmodel.dart';
import '../../ui/auth/viewmodels/register_viewmodel.dart';
import '../../ui/event/viewmodels/event_viewmodel.dart';
import '../../ui/team/viewmodels/team_viewmodel.dart';
import '../../ui/submission/viewmodels/submission_viewmodel.dart';
import '../../ui/profile/viewmodels/profile_viewmodel.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<DioClient>(() => DioClient());
  locator.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<TeamRemoteDataSource>(() => TeamRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<SubmitResultRemoteDataSource>(() => SubmitResultRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<EventRoleRemoteDataSource>(() => EventRoleRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<StorageRemoteDataSource>(() => StorageRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<TrackRemoteDataSource>(() => TrackRemoteDataSource(locator<DioClient>()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(locator<AuthRemoteDataSource>()));
  locator.registerLazySingleton<EventRepository>(() => EventRepository(locator<EventRemoteDataSource>()));
  locator.registerLazySingleton<TeamRepository>(() => TeamRepository(locator<TeamRemoteDataSource>()));
  locator.registerLazySingleton<SubmissionRepository>(() => SubmissionRepository(locator<SubmitResultRemoteDataSource>()));
  locator.registerLazySingleton<UserRepository>(() => UserRepository(locator<UserRemoteDataSource>()));
  locator.registerLazySingleton<EventRoleRepository>(() => EventRoleRepository(locator<EventRoleRemoteDataSource>()));
  locator.registerLazySingleton<StorageRepository>(() => StorageRepository(locator<StorageRemoteDataSource>()));
  locator.registerLazySingleton<TrackRepository>(() => TrackRepository(locator<TrackRemoteDataSource>()));

  // ViewModels
  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(locator<AuthRepository>(), locator<SecureStorageService>()),
  );
  locator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(locator<AuthRepository>(), locator<SecureStorageService>()),
  );
  locator.registerFactory<EventViewModel>(() => EventViewModel(locator<EventRepository>()));
  locator.registerFactory<TeamViewModel>(() => TeamViewModel(locator<TeamRepository>()));
  locator.registerFactory<SubmissionViewModel>(() => SubmissionViewModel(locator<SubmissionRepository>()));
  locator.registerLazySingleton<ProfileViewModel>(() => ProfileViewModel(locator<UserRepository>()));
}
