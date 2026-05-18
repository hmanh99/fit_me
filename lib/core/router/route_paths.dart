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
  static const signIn = '/auth/sign-in';
  static const signUp = '/auth/sign-up';
  static const forgotPassword = '/auth/forgot-password';

  ///redirect to [appHome] if user direct correctly to `/app`.
  static const app = '/app';

  static const appHome = '/app/home';

  static const appProgress = '/app/progress';

  static const appWorkouts = '/app/workouts';

  static const appProfile = '/app/profile';
  static const appProfileSettings = '/app/profile/settings';
  static const appProfileEdit = '/app/profile/edit';

  static const appMealPlanner = '/app/meal-planner';


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
