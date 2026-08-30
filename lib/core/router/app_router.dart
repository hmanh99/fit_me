import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/di/injection_container.dart' as di;
import 'package:fit_me/core/router/auth_redirect.dart';
import 'package:fit_me/core/router/go_router_refresh_stream.dart';
import 'package:fit_me/core/router/route_names.dart';
import 'package:fit_me/core/router/route_paths.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fit_me/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:fit_me/features/auth/presentation/screens/login_screen.dart';
import 'package:fit_me/features/auth/presentation/screens/signup_screen.dart';
import 'package:fit_me/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:fit_me/features/exercise/domain/usecases/get_exercise_by_id_use_case.dart';
import 'package:fit_me/features/exercise/domain/usecases/get_exercises_use_case.dart';
import 'package:fit_me/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:fit_me/features/exercise/presentation/screens/exercise_detail_screen.dart';
import 'package:fit_me/features/exercise/presentation/screens/exercise_screen.dart';
import 'package:fit_me/features/meal/presentation/screens/meal_detail_screen.dart';
import 'package:fit_me/features/meal/presentation/screens/meal_plan_screen.dart';
import 'package:fit_me/features/onboard/presentation/onboard_screen1.dart';
import 'package:fit_me/features/onboard/presentation/onboard_screen2.dart';
import 'package:fit_me/features/onboard/presentation/welcome_screen.dart';
import 'package:fit_me/features/profile/data/datasource/activity_history_remote_datasource.dart';
import 'package:fit_me/features/profile/data/repositories/activity_history_repository_impl.dart';
import 'package:fit_me/features/profile/domain/usecases/get_activity_heatmap_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/get_activity_histories_use_case.dart';
import 'package:fit_me/features/profile/presentation/bloc/activity_history_bloc.dart';
import 'package:fit_me/features/profile/presentation/screens/activity_history_screen.dart';
import 'package:fit_me/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:fit_me/features/profile/presentation/screens/profile_detail_screen.dart';
import 'package:fit_me/features/profile/presentation/screens/profile_screen.dart';
import 'package:fit_me/features/schedule/presentation/screens/schedule_screen.dart';
import 'package:fit_me/features/settings/presentation/screens/settings_screen.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fit_me/features/workout/domain/usecases/create_set_session_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/create_workout_session_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:fit_me/features/workout/presentation/screens/create_edit_plan_screen.dart';
import 'package:fit_me/features/workout/presentation/screens/workout_detail_screen.dart';
import 'package:fit_me/features/workout/presentation/screens/workout_screen.dart';
import 'package:fit_me/features/workout/presentation/screens/workout_session_screen.dart';
import 'package:fit_me/shared/widgets/main_shell.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutePaths.welcome,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      return resolveAuthRedirect(
        authState: authBloc.state,
        location: state.uri.toString(),
      );
    },
    routes: [
      ///onboard
      GoRoute(
        path: AppRoutePaths.welcome,
        name: AppRouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.onboardingStep1,
        name: AppRouteNames.onboardingStep1,
        builder: (context, state) => const OnboardScreen1(),
      ),
      GoRoute(
        path: AppRoutePaths.onboardingStep2,
        name: AppRouteNames.onboardingStep2,
        builder: (context, state) => const OnboardScreen2(),
      ),

      /// auth
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        builder: (context, state) {
          return LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutePaths.signUp,
        name: AppRouteNames.signUp,
        builder: (context, state) {
          return SignUpScreen();
        },
      ),
      GoRoute(
        path: AppRoutePaths.forgotPassword,
        name: AppRouteNames.forgotPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return ForgotPasswordScreen(initialEmail: email);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          /// dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appHome,
                name: AppRouteNames.appHome,
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  /// workout
                  GoRoute(
                    path: 'workout',
                    name: AppRouteNames.appWorkouts,
                    builder: (context, state) {
                      return BlocProvider<WorkoutBloc>(
                        create: (context) => di.serviceLocator<WorkoutBloc>(),
                        child: const WorkoutScreen(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'create-plan',
                        name: AppRouteNames.appCreatePlan,
                        builder: (context, state) {
                          return BlocProvider<WorkoutBloc>(
                            create: (context) => di.serviceLocator<WorkoutBloc>(),
                            child: const CreateEditPlanScreen(),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'edit-plan',
                        name: AppRouteNames.appEditPlan,
                        builder: (context, state) {
                          final plan = state.extra as WorkoutPlanEntity?;
                          return BlocProvider<WorkoutBloc>(
                            create: (context) => di.serviceLocator<WorkoutBloc>(),
                            child: CreateEditPlanScreen(initialPlan: plan),
                          );
                        },
                      ),
                      GoRoute(
                        path: ':workoutId',
                        name: AppRouteNames.appWorkoutDetail,
                        builder: (context, state) {
                          final workoutId = state.pathParameters['workoutId']!;
                          final String? planName =
                              state.uri.queryParameters['planName'];
                          return BlocProvider<WorkoutBloc>(
                            create: (context) => di.serviceLocator<WorkoutBloc>(),
                            child: WorkoutDetailScreen(
                              workoutId: int.parse(workoutId),
                              planName: planName ?? 'Workout Plan',
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'session',
                            name: AppRouteNames.appWorkoutSession,
                            builder: (context, state) {
                              final workoutPlan =
                                  state.extra as WorkoutPlanEntity?;
                              return BlocProvider<WorkoutSessionBloc>(
                                create: (context) {
                                  final repo = di
                                      .serviceLocator<WorkoutRepository>();
                                  final bloc = WorkoutSessionBloc(
                                    createWorkoutSession:
                                        CreateWorkoutSessionUseCase(repo),
                                    createSetSession: CreateSetSessionUseCase(
                                      repo,
                                    ),
                                  );
                                  if (workoutPlan != null) {
                                    bloc.add(
                                      StartWorkoutPlan(plan: workoutPlan),
                                    );
                                  }
                                  return bloc;
                                },
                                child: const WorkoutSessionScreen(),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'exercises/:exerciseId',
                            name: AppRouteNames.appWorkoutExerciseDetail,
                            builder: (context, state) {
                              final exerciseId =
                                  state.pathParameters['exerciseId']!;
                              return BlocProvider<ExerciseBloc>(
                                create: (context) {
                                  final repo = di
                                      .serviceLocator<ExerciseRepository>();
                                  return ExerciseBloc(
                                    getExercises: GetExercisesUseCase(repo),
                                    getExerciseById: GetExerciseByIdUseCase(
                                      repo,
                                    ),
                                  );
                                },
                                child: ExerciseDetailScreen(
                                  exerciseId: int.parse(exerciseId),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// exercise
                  GoRoute(
                    path: 'exercise',
                    name: AppRouteNames.appExercise,
                    builder: (context, state) {
                      return BlocProvider<ExerciseBloc>(
                        create: (context) {
                          final repo = di.serviceLocator<ExerciseRepository>();
                          return ExerciseBloc(
                            getExercises: GetExercisesUseCase(repo),
                            getExerciseById: GetExerciseByIdUseCase(repo),
                          );
                        },
                        child: const ExerciseScreen(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: ':exerciseId',
                        name: AppRouteNames.appExerciseDetail,
                        builder: (context, state) {
                          final exerciseId =
                              state.pathParameters['exerciseId']!;
                          return ExerciseDetailScreen(
                            exerciseId: int.parse(exerciseId),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          /// schedule
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appSchedule,
                name: AppRouteNames.appSchedule,
                builder: (context, state) => const ScheduleScreen(),
                routes: [],
              ),
            ],
          ),

          /// meal planner
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appMeal,
                name: AppRouteNames.appMeal,
                builder: (context, state) => const MealPlanScreen(),
                routes: [
                  GoRoute(
                    path: ':mealId',
                    name: AppRouteNames.appMealDetail,
                    builder: (context, state) {
                      final mealId = state.pathParameters['mealId']!;
                      return MealDetailScreen(mealId: int.parse(mealId));
                    },
                  ),
                ],
              ),
            ],
          ),

          /// profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appProfile,
                name: AppRouteNames.appProfile,
                builder: (context, state) {
                  final tab = state.uri.queryParameters['tab'];
                  return ProfileScreen(initialTab: tab);
                },
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: AppRouteNames.appProfileSettings,
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'activity-history',
                    name: AppRouteNames.appProfileActivityHistory,
                    builder: (context, state) {
                      final repo = ActivityHistoryRepositoryImpl(
                        remoteDatasource: ActivityHistoryRemoteDataSourceImpl(
                          supabaseClient: Supabase.instance.client,
                        ),
                      );
                      return BlocProvider<ActivityHistoryBloc>(
                        create: (context) => ActivityHistoryBloc(
                          getActivityHistories: GetActivityHistoriesUseCase(
                            repo,
                          ),
                          getActivityHeatmap: GetActivityHeatmapUseCase(
                            repo,
                          ),
                        ),
                        child: const ActivityHistoryScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':profileId',
                    name: AppRouteNames.appProfileDetail,
                    builder: (context, state) {
                      final profileId = state.pathParameters['profileId']!;
                      return ProfileDetailScreen(profileId: profileId);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: AppRouteNames.appProfileEdit,
                        builder: (context, state) {
                          final profileId = state.pathParameters['profileId']!;
                          return EditProfileScreen(profileId: profileId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      /// default app route redirect
      GoRoute(
        path: AppRoutePaths.app,
        redirect: (context, state) => AppRoutePaths.appHome,
      ),
    ],
  );
}
