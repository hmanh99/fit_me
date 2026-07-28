import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_exercise_card.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_error_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_loading_skeleton.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int workoutId;
  final String? planName;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
    this.planName,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late String _planName;

  @override
  void initState() {
    super.initState();
    _planName = widget.planName ?? "Workout Plan";
    context.read<WorkoutBloc>().add(
          WorkoutFetchPlanDetailsStarted(planId: widget.workoutId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          onPressed: () {
            context.goNamed(AppRouteNames.appWorkouts);
          },
        ),
        title: Text(
          _planName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        toolbarHeight: 64,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const WorkoutLoadingSkeleton(isDetailPage: true,);
          } else if (state is WorkoutError) {
            return WorkoutErrorState(
              errorMessage: state.message,
              onRetry: () {
                context.read<WorkoutBloc>().add(
                      WorkoutFetchPlanDetailsStarted(planId: widget.workoutId),
                    );
              },
            );
          } else if (state is WorkoutPlanDetailsLoaded) {
            final plan = state.workoutPlan;
            return RefreshIndicator(onRefresh: () async {
              context.read<WorkoutBloc>().add(
                WorkoutFetchPlanDetailsStarted(planId: widget.workoutId),
              );
            }, child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(plan),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Exercises List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: plan.planExercises.length,
                      itemBuilder: (context, index) {
                        final planEx = plan.planExercises[index];
                        return TweenAnimationBuilder<double>(
                          key: ValueKey(planEx.planExerciseId),
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 350 + (index * 60)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: WorkoutExerciseCard(
                            planExercise: planEx,
                            onTap: () {
                              context.goNamed(
                                AppRouteNames.appWorkoutExerciseDetail,
                                pathParameters: {
                                  'workoutId': plan.planId.toString().trim(),
                                  'exerciseId':
                                  planEx.exerciseId.toString().trim(),
                                },
                                queryParameters: {
                                  'exerciseName': planEx.exercise?.name.trim(),
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutPlanDetailsLoaded) {
            final plan = state.workoutPlan;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        AppRouteNames.appWorkoutSession,
                        pathParameters: {
                          'workoutId': plan.planId.toString(),
                        },
                        extra: plan,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shadowColor:
                          const Color(0xFF92A3FD).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Start Workout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderCard(WorkoutPlanEntity plan) {
    final totalSets = plan.planExercises.fold<int>(
      0,
      (sum, item) => sum + item.targetSets,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.planName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: plan.isDefaultPlan
                      ? const Color(0xFF7F77DD).withValues(alpha: 0.15)
                      : const Color(0xFFEEA282).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  plan.isDefaultPlan ? "Official" : "Personal",
                  style: TextStyle(
                    color: plan.isDefaultPlan
                        ? const Color(0xFF7F77DD)
                        : const Color(0xFFEEA282),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              plan.description!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Statistics row
          Row(
            children: [
              _buildStatChip(
                icon: Icons.fitness_center_rounded,
                label: "${plan.exerciseCount} Exercises",
                color: const Color(0xFF92A3FD),
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                icon: Icons.repeat_rounded,
                label: "$totalSets Total Sets",
                color: const Color(0xFF7F77DD),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
