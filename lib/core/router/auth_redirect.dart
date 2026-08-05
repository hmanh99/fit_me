import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';

/// Guard / redirect base on [AuthState] and current [URL].

String? resolveAuthRedirect({
  required AuthState authState,
  required String location,
}) {
  final uri = Uri.parse(location);
  final path = uri.path;

  final isLoggingIn = AppRoutePaths.isAuthPath(path);
  final isOnboarding = AppRoutePaths.isOnboardingPath(path);
  final isWelcome = path == AppRoutePaths.welcome;

  final authenticated = authState is AuthAuthenticatedState;

  // Session not init - bloc shell  -> welcome or null
  if (authState is AuthUnknownState) {
    if (AppRoutePaths.isAppShellPath(path)) {
      return AppRoutePaths.welcome;
    }
    return null;
  }

  // Un_auth -> sign in
  if (!authenticated) {
    if (AppRoutePaths.isAppShellPath(path)) {
      return Uri(
        path: AppRoutePaths.login,
        queryParameters: {'from': location},
        /// -> auth/[location]
      ).toString();
    }
    return null;
  }

  // auth -> dashboard.
  if (authenticated && (isWelcome || isOnboarding || isLoggingIn)) {
    return AppRoutePaths.appHome;
  }

  return null;
}
