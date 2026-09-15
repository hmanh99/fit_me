import 'package:fit_me/core/router/route_paths.dart';
import 'package:fit_me/features/auth/presentation/bloc/auth_state.dart';

/// Guard / redirect base on [AuthState] and current [URL].

String resolveAuthReturnLocation(String? rawLocation) {
  if (rawLocation == null || rawLocation.isEmpty) {
    return AppRoutePaths.appHome;
  }

  final uri = Uri.tryParse(rawLocation);
  if (uri == null ||
      uri.hasScheme ||
      uri.hasAuthority ||
      !AppRoutePaths.isAppShellPath(uri.path)) {
    return AppRoutePaths.appHome;
  }

  return uri.toString();
}

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
      /// -> auth/[location]
      return Uri(
        path: AppRoutePaths.login,
        queryParameters: {'from': location},
      ).toString();
    }
    return null;
  }

  // Preserve a protected deep link after authentication.
  if (authenticated && isLoggingIn) {
    return resolveAuthReturnLocation(uri.queryParameters['from']);
  }

  // Authenticated users do not need onboarding.
  if (authenticated && (isWelcome || isOnboarding)) {
    return AppRoutePaths.appHome;
  }

  return null;
}
