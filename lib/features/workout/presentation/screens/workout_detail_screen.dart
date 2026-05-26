import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(WorkoutFetchPlanDetailsStarted(planId: widget.workoutId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is WorkoutPlanDetailsLoaded) {
            final plan = state.workoutPlan;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(plan.planName, style: Theme.of(context).textTheme.headlineSmall),
                ),
                if (plan.description != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(plan.description!),
                  ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: plan.planExercises.length,
                    itemBuilder: (context, index) {
                      final planEx = plan.planExercises[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${planEx.orderInWorkout}')),
                        title: Text(planEx.exercise?.name ?? 'Unknown Exercise'),
                        subtitle: Text('${planEx.targetSets} sets x ${planEx.targetRepsOrSeconds} reps/secs'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          context.goNamed(
                            AppRouteNames.appExerciseDetail,
                            pathParameters: {
                              'workoutId': plan.planId.toString().trim(),
                              'exerciseId': planEx.exerciseId.toString().trim()
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
