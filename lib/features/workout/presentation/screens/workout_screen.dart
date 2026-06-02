import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_empty_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_error_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_loading_skeleton.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/workout_plan_card.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(const WorkoutFetchPlansStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Workout Plans",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const WorkoutLoadingSkeleton();
          } else if (state is WorkoutError) {
            return WorkoutErrorState(
              errorMessage: state.message,
              onRetry: () {
                context.read<WorkoutBloc>().add(
                      const WorkoutFetchPlansStarted(),
                    );
              },
            );
          } else if (state is WorkoutEmpty) {
            return WorkoutEmptyState(
              onRefresh: () {
                context.read<WorkoutBloc>().add(
                      const WorkoutFetchPlansStarted(),
                    );
              },
            );
          } else if (state is WorkoutPlansLoaded) {
            final plans = state.workoutPlans;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WorkoutBloc>().add(
                      const WorkoutFetchPlansStarted(),
                    );
              },
              color: const Color(0xFF92A3FD),
              backgroundColor: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  // Staggered slide & fade animation
                  return TweenAnimationBuilder<double>(
                    key: ValueKey(plan.planId),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 350 + (index * 60)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: WorkoutPlanCard(
                      plan: plan,
                      onTap: () => context.goNamed(
                        AppRouteNames.appWorkoutDetail,
                        pathParameters: {
                          'workoutId': plan.planId.toString(),
                        },
                        queryParameters: {
                          'planName': plan.planName,
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
