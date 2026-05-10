import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/auth_redirect.dart';
import 'package:personal_fitness_tracker/core/router/go_router_refresh_stream.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/core/router/shell/main_shell_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/forgot_password_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signin_screen.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/signup_screen.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:personal_fitness_tracker/features/dashboard/presentation/workout_detail_screen.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/onboard_screen1.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/onboard_screen2.dart';
import 'package:personal_fitness_tracker/features/onboard/presentation/welcome_screen.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/profile_screen.dart';
import 'package:personal_fitness_tracker/features/workouts/presentation/workouts_screen.dart';

/// Factory [GoRouter] — tách khỏi [MaterialApp] để test & inject dễ dàng.
///
/// [BlocProvider] của [AuthBloc] phải bọc phía trên [MaterialApp.router]
/// (hoặc truyền bloc vào đây như hiện tại).
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
        builder: (context, state) => const SignUpScreen(),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appHome,
                name: AppRouteNames.appHome,
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'workout/:workoutId',
                    name: AppRouteNames.workoutDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['workoutId']!;
                      return WorkoutDetailScreen(
                        workoutId: id,
                        extra: state.extra,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appWorkouts,
                name: AppRouteNames.appWorkouts,
                builder: (context, state) => const WorkoutsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.appProfile,
                name: AppRouteNames.appProfile,
                builder: (context, state) {
                  final tab = state.uri.queryParameters['tab'];
                  return ProfileScreen(initialTab: tab);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.app,
        redirect: (context, state) => AppRoutePaths.appHome,
      ),
    ],
  );
}
