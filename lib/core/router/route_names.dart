/// Tên route cho [GoRoute.name], `context.pushNamed`, `context.goNamed`.
abstract final class AppRouteNames {
  AppRouteNames._();

  static const welcome = 'welcome';

  static const onboardingStep1 = 'onboarding-step-1';
  static const onboardingStep2 = 'onboarding-step-2';

  static const signIn = 'sign-in';
  static const signUp = 'sign-up';
  static const forgotPassword = 'forgot-password';

  static const appHome = 'app-home';

  static const appWorkouts = 'app-workout';
  static const appWorkoutDetail = 'app-workout-detail';
  static const appExerciseDetail = 'app-exercise-detail';

  static const appProfile = 'app-profile';
  static const appProfileSettings = 'app-profile-settings';
  static const appProfileEdit = 'app-profile-edit';

  static const appProgress = 'app-schedule';

  static const appMealPlanner = 'app-meal-planner';
}
