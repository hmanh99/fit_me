import 'package:fit_me/core/services/auth_services.dart';
import 'package:fit_me/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:fit_me/core/config/app_config.dart';
import 'package:fit_me/core/services/exercise_services.dart';
import 'package:fit_me/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fit_me/features/auth/domain/repositories/auth_repository.dart';
import 'package:fit_me/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:fit_me/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:fit_me/features/auth/domain/usecases/login_use_case.dart';
import 'package:fit_me/features/auth/domain/usecases/logout_use_case.dart';
import 'package:fit_me/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:fit_me/features/auth/domain/usecases/watch_auth_state_use_case.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_event.dart';
import 'package:fit_me/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:fit_me/features/exercise/data/datasource/exercise_remote_data_source.dart';
import 'package:fit_me/features/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:fit_me/features/exercise/domain/usecases/get_exercise_by_id_use_case.dart';
import 'package:fit_me/features/exercise/domain/usecases/get_exercises_use_case.dart';
import 'package:fit_me/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:fit_me/features/meal/data/datasources/meal_remote_datasource.dart';
import 'package:fit_me/features/meal/data/repositories/meal_repository_impl.dart';
import 'package:fit_me/features/meal/domain/repositories/meal_repository.dart';
import 'package:fit_me/features/meal/domain/usecases/get_meal_by_id_use_case.dart';
import 'package:fit_me/features/meal/domain/usecases/get_meals_use_case.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:fit_me/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:fit_me/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fit_me/features/profile/domain/usecases/get_current_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/logout_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fit_me/features/schedule/data/datasource/schedule_remote_data_source.dart';
import 'package:fit_me/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fit_me/features/schedule/domain/usecases/add_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/delete_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/get_schedules_by_month_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/update_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/watch_schedules_use_case.dart';
import 'package:fit_me/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:fit_me/features/settings/domain/repositories/settings_repository.dart';
import 'package:fit_me/features/settings/domain/usecases/get_settings_use_case.dart';
import 'package:fit_me/features/settings/domain/usecases/save_language_code_use_case.dart';
import 'package:fit_me/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:fit_me/features/workout/data/datasource/workout_remote_data_source.dart';
import 'package:fit_me/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plan_details_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plans_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton<SupabaseClient>(
        () => Supabase.instance.client,
  );

  serviceLocator.registerLazySingleton<ExerciseServices>(
        () => ExerciseServices(),
  );
  serviceLocator.registerLazySingleton<AuthServices>(() => AuthServices(),);

  // Auth

  serviceLocator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDatasource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthRemoteDatasource >(
        () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
        () => GetCurrentUserUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => LoginUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignUpUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
        () => ForgotPasswordUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => LogoutUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
        () => WatchAuthStateUseCase(serviceLocator()),
  );

  /// it can start
  /// restoring the session before runApp and is provided down the tree via
  /// BlocProvider.value => must resolve to the same instance every time.
  serviceLocator.registerLazySingleton<AuthBloc>(
        () => AuthBloc(
      getCurrentUser: serviceLocator(),
      login: serviceLocator(),
      signUp: serviceLocator(),
      forgotPassword: serviceLocator(),
      logout: serviceLocator(),
      watchAuthState: serviceLocator(),
    )..add(const AuthSessionRestoreRequested()),
  );

  /// Workout
  serviceLocator.registerLazySingleton<WorkoutRemoteDataSource>(
        () => WorkoutRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<WorkoutRepository>(
        () => WorkoutRepositoryImpl(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => GetWorkoutPlansUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => GetWorkoutPlanDetailsUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory<WorkoutBloc>(
        () => WorkoutBloc(
      getWorkoutPlans: serviceLocator(),
      getWorkoutPlanDetails: serviceLocator(),
    ),
  );

  /// Exercise

  serviceLocator.registerLazySingleton<ExerciseRemoteDataSource>(
        () => ExerciseRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ExerciseRepository>(
        () => ExerciseRepositoryImpl(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => GetExercisesUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => GetExerciseByIdUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory<ExerciseBloc>(
        () => ExerciseBloc(
      getExercises: serviceLocator(),
      getExerciseById: serviceLocator(),
    ),
  );

  /// Schedule

  serviceLocator.registerLazySingleton<ScheduleRemoteDataSource>(
        () => ScheduleRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<ScheduleRepository>(
        () => ScheduleRepositoryImpl(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => GetSchedulesByMonthUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => AddScheduleUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => UpdateScheduleUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => DeleteScheduleUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => WatchSchedulesUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory<ScheduleBloc>(
        () => ScheduleBloc(
      getSchedulesByMonth: serviceLocator(),
      addSchedule: serviceLocator(),
      updateSchedule: serviceLocator(),
      deleteSchedule: serviceLocator(),
      watchSchedules: serviceLocator(),
    ),
  );

  /// Meal

  serviceLocator.registerLazySingleton<MealRemoteDatasource>(
        () => MealRemoteDatasourceImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<MealRepository>(
        () => MealRepositoryImpl(remoteDatasource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => GetMealsUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
        () => GetMealByIdUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory<MealBloc>(
        () => MealBloc(getMeals: serviceLocator(), getMealById: serviceLocator()),
  );

  /// Profile
  serviceLocator.registerLazySingleton<ProfileRemoteDatasource>(
        () => ProfileRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoriesImpl(remoteDatasource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => GetCurrentProfileUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => UpdateProfileUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => LogoutProfileUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory<ProfileBloc>(
        () => ProfileBloc(
      getCurrentProfile: serviceLocator(),
      updateProfile: serviceLocator(),
      logoutProfile: serviceLocator(),
    ),
  );

  /// Dashboard
  serviceLocator.registerFactory<DashboardBloc>(
        () => DashboardBloc(exerciseServices: serviceLocator()),
  );

  /// Settings
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
        () => sharedPreferences,
  );

  // Data Sources
  serviceLocator.registerLazySingleton<SettingsLocalDataSource>(
        () => SettingsLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
        () => GetSettingsUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
        () => SaveLanguageCodeUseCase(serviceLocator()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(localDataSource: serviceLocator()),
  );

  // Cubits / Blocs
  serviceLocator.registerFactory<SettingsBloc>(
        () => SettingsBloc(
      getSettings: serviceLocator(),
      saveLanguageCode: serviceLocator(),
    ),
  );
}