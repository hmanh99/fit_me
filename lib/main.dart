import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/di/injection_container.dart'
    as di;
import 'package:personal_fitness_tracker/core/router/app_router.dart';
import 'package:personal_fitness_tracker/core/services/exercise_services.dart';
import 'package:personal_fitness_tracker/core/theme/app_theme.dart';
import 'package:personal_fitness_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/data/datasource/exercise_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/meal/data/datasources/meal_remote_datasource.dart';
import 'package:personal_fitness_tracker/features/meal/data/repositories/meal_repository_impl.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:personal_fitness_tracker/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:personal_fitness_tracker/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:personal_fitness_tracker/features/schedule/data/datasource/schedule_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/bloc/settings_event.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/bloc/settings_state.dart';
import 'package:personal_fitness_tracker/features/workout/data/datasource/workout_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();

  await Supabase.initialize(
    url: 'https://rrwpymefmyqnxeeithst.supabase.co',
    anonKey: 'sb_publishable_mK5OJp-IdJ3q1r1xR9-78w_rb6v1ELz',
  );

  final authBloc = AuthBloc(authRepository: AuthRepositoryImpl())
    ..add(const AuthSessionRestoreRequested());

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(authBloc: authBloc),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({required this.authBloc, super.key});

  final AuthBloc authBloc;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = createAppRouter(widget.authBloc);

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)?.locale;
    return BlocProvider<SettingsBloc>(
      create: (_) => di.sl<SettingsBloc>()..add(const SettingsLoadRequested()),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<WorkoutRepositoryImpl>(
            create: (context) => WorkoutRepositoryImpl(
              remoteDataSource: WorkoutRemoteDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
          RepositoryProvider<ExerciseRepositoryImpl>(
            create: (context) => ExerciseRepositoryImpl(
              remoteDataSource: ExerciseRemoteDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
          RepositoryProvider<ScheduleRepositoryImpl>(
            create: (context) => ScheduleRepositoryImpl(
              remoteDataSource: ScheduleRemoteDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
          RepositoryProvider<MealRepositoryImpl>(
            create: (context) => MealRepositoryImpl(
              remoteDatasource: MealRemoteDatasourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
          RepositoryProvider<ProfileRepositoriesImpl>(
            create: (context) => ProfileRepositoriesImpl(
              remoteDatasource: ProfileRemoteDataSourceImpl(
                supabaseClient: Supabase.instance.client,
              ),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: widget.authBloc),
            BlocProvider<WorkoutBloc>(
              create: (context) => WorkoutBloc(
                workoutRepository: context.read<WorkoutRepositoryImpl>(),
              ),
            ),
            BlocProvider<ExerciseBloc>(
              create: (context) => ExerciseBloc(
                exerciseRepository: context.read<ExerciseRepositoryImpl>(),
              ),
            ),
            BlocProvider<ScheduleBloc>(
              create: (context) => ScheduleBloc(
                scheduleRepository: context.read<ScheduleRepositoryImpl>(),
              ),
            ),
            BlocProvider<MealBloc>(
              create: (context) =>
                  MealBloc(mealRepository: context.read<MealRepositoryImpl>()),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(
                repositories: context.read<ProfileRepositoriesImpl>(),
              ),
            ),
            BlocProvider<DashboardBloc>(
              create: (context) =>
                  DashboardBloc(exerciseServices: ExerciseServices()),
            ),
          ],
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              return BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, next) =>
                    prev is AuthUnknownState || next is AuthUnknownState,
                builder: (context, authState) {
                  return MaterialApp.router(
                    title: 'Personal Fitness Tracker',
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    theme: AppTheme.light,
                    debugShowCheckedModeBanner: false,
                    routerConfig: _router,
                    builder: (context, child) {
                      if (authState is AuthUnknownState) {
                        return const CircularProgressIndicator();
                      }
                      return child ?? const CircularProgressIndicator();
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
