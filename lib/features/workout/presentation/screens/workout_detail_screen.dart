import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';

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
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            onPressed: () {
              context.goNamed(AppRouteNames.appWorkouts);
            },
          ),
        ),
        title: Row(
          children: [
            Text(
              _planName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ],
        ),
        toolbarHeight: 60,
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is WorkoutPlanDetailsLoaded) {
            final plan = state.workoutPlan;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: plan.planExercises.length,
                      itemBuilder: (context, index) {
                        final planEx = plan.planExercises[index];
                        return ExerciseCard(
                          orderInWorkout: planEx.orderInWorkout,
                          exerciseName: planEx.exercise?.name ?? "",
                          targetSets: planEx.targetSets,
                          targetRepsOrSeconds: planEx.targetRepsOrSeconds,
                          onTap: () {
                            context.goNamed(
                              AppRouteNames.appExerciseDetail,
                              pathParameters: {
                                'workoutId': plan.planId.toString().trim(),
                                'exerciseId': planEx.exerciseId
                                    .toString()
                                    .trim(),
                              },
                              queryParameters: {
                                'exerciseName': planEx.exercise?.name.trim(),
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final int orderInWorkout;
  final String exerciseName;
  final int targetSets;
  final int targetRepsOrSeconds;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.orderInWorkout,
    required this.exerciseName,
    required this.targetSets,
    required this.targetRepsOrSeconds,
    this.onTap,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  alignment: Alignment.center,
                  child: Text("${widget.orderInWorkout}"),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exerciseName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      ...[
                        Text(
                          "${widget.targetSets} x ${widget.targetRepsOrSeconds} sets/seconds",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
