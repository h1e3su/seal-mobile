import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/services/google_auth_service.dart';
import '../../core/context/user_role_context.dart';

// Data Sources
import '../../data/services/auth_remote_datasource.dart';
import '../../data/services/event_remote_datasource.dart';
import '../../data/services/team_remote_datasource.dart';
import '../../data/services/submit_result_remote_datasource.dart';
import '../../data/services/user_remote_datasource.dart';
import '../../data/services/event_role_remote_datasource.dart';
import '../../data/services/storage_remote_datasource.dart';
import '../../data/services/track_remote_datasource.dart';
import '../../data/services/score_remote_datasource.dart';
import '../../data/services/final_result_remote_datasource.dart';
import '../../data/services/appeal_remote_datasource.dart';

// Repositories
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/team_repository.dart';
import '../../data/repositories/submission_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/event_role_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/track_repository.dart';
import '../../data/repositories/score_repository.dart';
import '../../data/repositories/final_result_repository.dart';
import '../../data/repositories/appeal_repository.dart';

// ViewModels
import '../../ui/auth/viewmodels/login_viewmodel.dart';
import '../../ui/auth/viewmodels/register_viewmodel.dart';
import '../../ui/event/viewmodels/event_viewmodel.dart';
import '../../ui/team/viewmodels/team_viewmodel.dart';
import '../../ui/submission/viewmodels/submission_viewmodel.dart';
import '../../ui/profile/viewmodels/profile_viewmodel.dart';
import '../../ui/common/viewmodels/user_role_viewmodel.dart';
import '../../ui/home/viewmodels/home_viewmodel.dart';
import '../../ui/mentor/viewmodels/mentor_dashboard_viewmodel.dart';
import '../../ui/mentor/viewmodels/mentor_ranking_viewmodel.dart';
import '../../ui/mentor/viewmodels/mentor_viewmodel.dart';
import '../../ui/mentor/viewmodels/team_score_breakdown_viewmodel.dart';
import '../../ui/appeals/viewmodels/appeals_viewmodel.dart';
import '../../ui/notifications/viewmodels/notifications_viewmodel.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Services & Context (Singletons)
  locator.registerLazySingleton<DioClient>(() => DioClient());
  locator.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  locator.registerLazySingleton<GoogleAuthService>(() => GoogleAuthService());
  locator.registerLazySingleton<UserRoleContext>(() => UserRoleContext());

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<TeamRemoteDataSource>(() => TeamRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<SubmitResultRemoteDataSource>(() => SubmitResultRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<EventRoleRemoteDataSource>(() => EventRoleRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<StorageRemoteDataSource>(() => StorageRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<TrackRemoteDataSource>(() => TrackRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<ScoreRemoteDataSource>(() => ScoreRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<FinalResultRemoteDataSource>(() => FinalResultRemoteDataSource(locator<DioClient>()));
  locator.registerLazySingleton<AppealRemoteDataSource>(() => AppealRemoteDataSource(locator<DioClient>()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository(locator<AuthRemoteDataSource>()));
  locator.registerLazySingleton<EventRepository>(() => EventRepository(locator<EventRemoteDataSource>()));
  locator.registerLazySingleton<TeamRepository>(() => TeamRepository(locator<TeamRemoteDataSource>()));
  locator.registerLazySingleton<SubmissionRepository>(() => SubmissionRepository(locator<SubmitResultRemoteDataSource>()));
  locator.registerLazySingleton<UserRepository>(() => UserRepository(locator<UserRemoteDataSource>()));
  locator.registerLazySingleton<EventRoleRepository>(() => EventRoleRepository(locator<EventRoleRemoteDataSource>()));
  locator.registerLazySingleton<StorageRepository>(() => StorageRepository(locator<StorageRemoteDataSource>()));
  locator.registerLazySingleton<TrackRepository>(() => TrackRepository(locator<TrackRemoteDataSource>()));
  locator.registerLazySingleton<ScoreRepository>(() => ScoreRepository(locator<ScoreRemoteDataSource>()));
  locator.registerLazySingleton<FinalResultRepository>(() => FinalResultRepository(locator<FinalResultRemoteDataSource>()));
  locator.registerLazySingleton<AppealRepository>(() => AppealRepository(locator<AppealRemoteDataSource>()));

  // ViewModels (Factories for per-view lifecycle)
  locator.registerLazySingleton<UserRoleViewModel>(() => UserRoleViewModel(locator<EventRoleRepository>()));
  locator.registerFactory<HomeViewModel>(
    () => HomeViewModel(locator<EventRoleRepository>(), locator<UserRoleContext>()),
  );
  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      locator<AuthRepository>(),
      locator<SecureStorageService>(),
      locator<GoogleAuthService>(),
    ),
  );
  locator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(locator<AuthRepository>()),
  );
  locator.registerFactory<EventViewModel>(() => EventViewModel(locator<EventRepository>()));
  locator.registerFactory<TeamViewModel>(() => TeamViewModel(locator<TeamRepository>()));
  locator.registerFactory<SubmissionViewModel>(() => SubmissionViewModel(locator<SubmissionRepository>()));
  locator.registerLazySingleton<ProfileViewModel>(() => ProfileViewModel(locator<UserRepository>()));
  locator.registerFactory<AppealsViewModel>(() => AppealsViewModel(locator<AppealRepository>()));
  locator.registerFactory<NotificationsViewModel>(
    () => NotificationsViewModel(
      locator<UserRepository>(),
      locator<TeamRepository>(),
      locator<EventRoleRepository>(),
    ),
  );
  locator.registerFactory<MentorViewModel>(
    () => MentorViewModel(
      locator<TrackRepository>(),
      locator<TeamRepository>(),
      locator<ScoreRepository>(),
      locator<FinalResultRepository>(),
    ),
  );
  locator.registerFactory<MentorDashboardViewModel>(
    () => MentorDashboardViewModel(locator<TeamRepository>(), locator<UserRoleContext>()),
  );
  locator.registerFactory<TeamScoreBreakdownViewModel>(
    () => TeamScoreBreakdownViewModel(locator<ScoreRepository>()),
  );
  locator.registerFactory<MentorRankingViewModel>(
    () => MentorRankingViewModel(locator<FinalResultRepository>()),
  );
}
