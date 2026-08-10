import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/di/injection_container.dart'
    as di;
import 'package:personal_fitness_tracker/core/router/app_router.dart';
import 'package:personal_fitness_tracker/core/theme/app_theme.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/bloc/settings_event.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/bloc/settings_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await di.init();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AuthBloc is a singleton in the DI container, so the router (which
  // depends on it for auth-based redirects) is built once here.
  late final AuthBloc _authBloc = di.serviceLocator<AuthBloc>();
  late final GoRouter _router = createAppRouter(_authBloc);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) =>
              di.serviceLocator<SettingsBloc>()
                ..add(const SettingsLoadRequested()),
        ),
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<WorkoutBloc>(
          create: (_) => di.serviceLocator<WorkoutBloc>(),
        ),
        BlocProvider<ExerciseBloc>(
          create: (_) => di.serviceLocator<ExerciseBloc>(),
        ),
        BlocProvider<ScheduleBloc>(
          create: (_) => di.serviceLocator<ScheduleBloc>(),
        ),
        BlocProvider<MealBloc>(create: (_) => di.serviceLocator<MealBloc>()),
        BlocProvider<ProfileBloc>(
          create: (_) => di.serviceLocator<ProfileBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => di.serviceLocator<DashboardBloc>(),
        ),
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (prev, next) =>
            prev.settings.languageCode != next.settings.languageCode,
        listener: (context, state) {
          context.setLocale(Locale(state.settings.languageCode));
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (prev, next) =>
                  prev is AuthUnknownState || next is AuthUnknownState,
              builder: (context, authState) {
                return MaterialApp.router(
                  title: 'FitMe',
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
    );
  }
}
