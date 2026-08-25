/// Tên route cho [GoRoute.name], context.pushNamed, context.goNamed.
abstract final class AppRouteNames {
  AppRouteNames._();

  static const welcome = 'welcome';

  static const onboardingStep1 = 'onboarding-step-1';
  static const onboardingStep2 = 'onboarding-step-2';

  static const login = 'login';
  static const signUp = 'sign-up';
  static const forgotPassword = 'forgot-password';

  static const appHome = 'app-home';

  static const appWorkouts = 'app-workout';
  static const appWorkoutDetail = 'app-workout-detail';
  static const appWorkoutSession = 'app-workout-session';
  static const appCreatePlan = 'app-create-plan';
  static const appEditPlan = 'app-edit-plan';

  static const appExercise = 'app-exercise';
  static const appWorkoutExerciseDetail = 'app-workout-exercise-detail';
  static const appExerciseDetail = 'app-exercise-detail';

  static const appProfile = 'app-profile';
  static const appProfileSettings = 'app-profile-settings';
  static const appProfileEdit = 'app-profile-edit';
  static const appProfileDetail = 'app-profile-detail';
  static const appProfileActivityHistory = 'app-profile-activity-history';

  static const appSchedule = 'app-schedule';

  static const appMeal = 'app-meal';
  static const appMealDetail = 'app-meal-detail';
}
