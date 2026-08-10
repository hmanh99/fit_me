import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_paths.dart';
import 'package:fit_me/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:fit_me/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:fit_me/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:fit_me/features/dashboard/presentation/widgets/dashboard_empty_recommendations.dart';
import 'package:fit_me/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:fit_me/features/dashboard/presentation/widgets/dashboard_recommendations_error.dart';
import 'package:fit_me/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:fit_me/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:fit_me/features/dashboard/presentation/widgets/recommendation_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  void _fetchExercises() {
    context.read<DashboardBloc>().add(const DashboardExercisesFetched());
  }

  Future<void> _onRefresh() async {
    _fetchExercises();
    context.read<DashboardBloc>().add(DashboardExercisesFetched());
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: ColorConstants.buttonColor,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: const DashboardSkeleton(),
                ),
              ),
            );
          }
          if (state is DashboardError) {
            return DashboardRecommendationsError(
              errorMessage: state.message,
              onRetry: _fetchExercises,
            );
          }

          final exercises = state is DashboardExercisesFetchedSuccess
              ? state.exercises
              : <Map<String, dynamic>>[];

          // Empty
          if (state is DashboardEmpty || exercises.isEmpty) {
            return DashboardEmptyRecommendations(onRefresh: _fetchExercises);
          }

          return SafeArea(
            child: RefreshIndicator(
              color: ColorConstants.buttonColor,
              backgroundColor: ColorConstants.backgroundColor,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(),
                    const SizedBox(height: 24),

                    _SectionLabel(label: 'quick_actions'.tr()),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2,
                      children: [
                        QuickActionButton(
                          icon: Icons.fitness_center_rounded,
                          label: 'workout_plans'.tr(),
                          onTap: () => context.push(AppRoutePaths.appWorkout),
                        ),
                        QuickActionButton(
                          icon: Icons.sports_gymnastics_outlined,
                          label: 'exercises_library'.tr(),
                          onTap: () => context.push(AppRoutePaths.appExercise),
                        ),
                        QuickActionButton(
                          icon: Icons.calendar_month_rounded,
                          label: 'my_schedule'.tr(),
                          onTap: () => context.go(AppRoutePaths.appSchedule),
                        ),
                        QuickActionButton(
                          icon: Icons.restaurant_rounded,
                          label: 'meal_idea'.tr(),
                          onTap: () => context.go(AppRoutePaths.appMeal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SectionLabel(label: 'recommendations'.tr()),
                        GestureDetector(
                          onTap: () => context.push(AppRoutePaths.appExercise),
                          child: Row(
                            children: [
                              Text(
                                'see_all'.tr(),
                                style: const TextStyle(
                                  color: ColorConstants.textHighlightColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: ColorConstants.textHighlightColor,
                                size: 13,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (exercises.length % 10).clamp(2, 5),
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return RecommendationCard(
                            exercise: exercise,
                            onTap: () {
                              final rawExerciseId = exercise['exercise_id'];
                              if (rawExerciseId != null) {
                                final exerciseId = int.tryParse(
                                  rawExerciseId.toString(),
                                );
                                if (exerciseId != null) {
                                  context.push(
                                    '${AppRoutePaths.appExercise}/$exerciseId',
                                  );
                                  return;
                                }
                              }
                              context.push(AppRoutePaths.appExercise);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
