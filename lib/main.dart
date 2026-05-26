import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/app_router.dart';
import 'package:personal_fitness_tracker/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:personal_fitness_tracker/features/exercise/data/datasources/exercise_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/data/datasources/workout_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/shared/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rrwpymefmyqnxeeithst.supabase.co',
    anonKey: 'sb_publishable_mK5OJp-IdJ3q1r1xR9-78w_rb6v1ELz',
  );

  final authBloc = AuthBloc(authRepository: AuthRepositoryImpl())
    ..add(const AuthSessionRestoreRequested());

  runApp(MyApp(authBloc: authBloc));
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
    return MultiRepositoryProvider(
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
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (prev, next) =>
              prev is AuthUnknownState || next is AuthUnknownState,
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Personal Fitness Tracker',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              builder: (context, child) {
                if (state is AuthUnknownState) return const SplashScreen();
                return child ?? const SplashScreen();
              },
            );
          },
        ),
      ),
    );
  }
}
