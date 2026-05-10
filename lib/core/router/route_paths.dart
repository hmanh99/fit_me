/// Canonical URL paths for deep linking & redirects.
///
/// Dùng cho [GoRouter] `path`, `context.go`, và kiểm tra `state.matchedLocation`.
abstract final class AppRoutePaths {
  AppRoutePaths._();

  static const welcome = '/welcome';

  static const onboarding = '/onboarding';
  static const onboardingStep1 = '/onboarding/step-1';
  static const onboardingStep2 = '/onboarding/step-2';

  static const auth = '/auth';
  static const signIn = '/auth/sign-in';
  static const signUp = '/auth/sign-up';
  static const forgotPassword = '/auth/forgot-password';

  /// Shell gốc — redirect sang [appHome] nếu user vào đúng `/app`.
  static const app = '/app';
  static const appHome = '/app/home';
  static const appWorkouts = '/app/workouts';
  static const appProfile = '/app/profile';

  /// Ví dụ nested route dưới tab Home (path param + deep link).
  static String appWorkoutDetail(String workoutId) =>
      '/app/home/workout/$workoutId';

  static bool isAuthPath(String location) {
    final path = Uri.parse(location).path;
    return path.startsWith(auth);
  }

  static bool isOnboardingPath(String location) {
    final path = Uri.parse(location).path;
    return path.startsWith(onboarding);
  }

  static bool isAppShellPath(String location) {
    final path = Uri.parse(location).path;
    return path.startsWith(app);
  }
}
