import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';

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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Workout Plans",
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
          } else if (state is WorkoutEmpty) {
            return const Center(child: Text('No workout plans available.'));
          } else if (state is WorkoutPlansLoaded) {
            final plans = state.workoutPlans;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WorkoutBloc>().add(
                  const WorkoutFetchPlansStarted(),
                );
              },
              child: ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return WorkOutPlanCard(
                    planName: plan.planName,
                    description: plan.description,
                    onTap: () => context.goNamed(
                      AppRouteNames.appWorkoutDetail,
                      pathParameters: {'workoutId': plan.planId.toString()},
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

class WorkOutPlanCard extends StatefulWidget {
  final String planName;
  final String? description;
  final int? durationMinutes;
  final VoidCallback? onTap;

  const WorkOutPlanCard({
    super.key,
    required this.planName,
    this.description,
    this.durationMinutes,
    this.onTap,
  });

  @override
  State<WorkOutPlanCard> createState() => _WorkOutPlanCardState();
}

class _WorkOutPlanCardState extends State<WorkOutPlanCard> {
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
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1542F6), Color(0xFF228EF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.planName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (widget.description != null &&
                          widget.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14,
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