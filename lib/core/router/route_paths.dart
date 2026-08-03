/// Canonical URL paths for deep linking & redirects.
/// Use [GoRouter] for `path`, `context.go`, and check `state.matchedLocation`.
///
abstract final class AppRoutePaths {
  AppRoutePaths._();

  static const welcome = '/welcome';

  static const onboarding = '/onboarding';
  static const onboardingStep1 = '/onboarding/step-1';
  static const onboardingStep2 = '/onboarding/step-2';

  static const auth = '/auth';
  static const login = '/auth/login';
  static const signUp = '/auth/sign-up';
  static const forgotPassword = '/auth/forgot-password';

  ///redirect to [appHome] if user direct correctly to `/app`.
  static const app = '/app';

  static const appHome = '/app/home';

  static const appSchedule = '/app/home/schedule';

  static const appWorkout = '/app/home/workout';
  static const appWorkoutSession = '/app/home/workout/session';

  static const appExercise = '/app/home/exercise';

  static const appMeal = '/app/meal';

  static const appProfile = '/app/profile';
  static const appProfileSettings = '/app/profile/settings';
  static const appProfileEdit = '/app/profile/edit';
  static const appProfileActivityHistory = '/app/profile/activity-history';



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
