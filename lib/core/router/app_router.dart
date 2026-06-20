import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/auth_redirect.dart';
import 'package:personal_fitness_tracker/core/router/go_router_refresh_stream.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/forgot_password_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signin_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signup_screen.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:personal_fitness_tracker/features/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/screens/exercise_detail_screen.dart';
import 'package:personal_fitness_tracker/features/meal_plan/presentation/meal_plan_screen.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/onboard_screen1.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/onboard_screen2.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/welcome_screen.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/screens/profile_detail_screen.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/screens/schedule_screen.dart';
import 'package:personal_fitness_tracker/features/settings/presentation/settings_screen.dart';
import 'package:personal_fitness_tracker/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/screens/workout_detail_screen.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/screens/workout_screen.dart';
import 'package:personal_fitness_tracker/shared/widgets/main_shell.dart';

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
      GoRoute(
        path: AppRoutePaths.signIn,
        name: AppRouteNames.signIn,
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return SignInScreen(returnTo: from);
        },
      ),
      GoRoute(
        path: AppRoutePaths.signUp,
        name: AppRouteNames.signUp,
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return SignUpScreen(returnTo: from);
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
          ///dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appHome,
                name: AppRouteNames.appHome,
                builder: (context, state) => const DashboardScreen(),
                routes: [],
              ),
            ],
          ),

          ///workouts
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appWorkouts,
                name: AppRouteNames.appWorkouts,
                builder: (context, state) => BlocProvider<WorkoutBloc>(
                  create: (context) => WorkoutBloc(
                    workoutRepository: context.read<WorkoutRepositoryImpl>(),
                  ),
                  child: const WorkoutScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':workoutId',
                    name: AppRouteNames.appWorkoutDetail,
                    builder: (context, state) {
                      final workoutId = state.pathParameters['workoutId']!;
                      final String? planName =
                          state.uri.queryParameters['planName'];
                      return BlocProvider<WorkoutBloc>(
                        create: (context) => WorkoutBloc(
                          workoutRepository: context
                              .read<WorkoutRepositoryImpl>(),
                        ),
                        child: WorkoutDetailScreen(
                          workoutId: int.parse(workoutId),
                          planName: planName ?? "Workout Plan",
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'exercises/:exerciseId',
                        name: AppRouteNames.appExerciseDetail,
                        builder: (context, state) {
                          final exerciseId =
                              state.pathParameters['exerciseId']!;
                          final String? exerciseName =
                              state.uri.queryParameters['exerciseName'];
                          return BlocProvider<ExerciseBloc>(
                            create: (context) => ExerciseBloc(
                              exerciseRepository: context
                                  .read<ExerciseRepositoryImpl>(),
                            ),
                            child: ExerciseDetailScreen(
                              exerciseId: int.parse(exerciseId),
                              exerciseName: exerciseName ?? "Exercise Detail",
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          ///progress
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appProgress,
                name: AppRouteNames.appProgress,
                builder: (context, state) {
                  return const ScheduleScreen();
                },
              ),
            ],
          ),

          ///meal plan
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appMealPlanner,
                name: AppRouteNames.appMealPlanner,
                builder: (context, state) {
                  return const MealPlanScreen();
                },
              ),
            ],
          ),

          ///profile
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
