import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/core/helper/format_duration.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/confirm_exit.dart';

import '../widgets/session_summary_card.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen( {super.key, required this.state, required this.context});

  final WorkoutSessionState state;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: ColorConstants.white,
            size: 30,
          ),
          onPressed: () => showExitConfirmationDialog(context),
        ),
        toolbarHeight: 64,
        title: const Text(
          'Workout Summary',
          style: TextStyle(
            color: ColorConstants.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: ColorConstants.primaryColor),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      size: 64,
                      color: ColorConstants.yellow,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        color: ColorConstants.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You completed ${state.plan.planName}',
                      style: TextStyle(
                        color: ColorConstants.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Metrics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  SummaryCard(
                    icon: Icons.timer_outlined,
                    label: 'Total Duration',
                    value: formatDuration(state.elapsedSeconds),
                    color: ColorConstants.primaryColor,
                  ),
                  SummaryCard(
                    icon: Icons.fitness_center_rounded,
                    label: 'Total Volume',
                    value: '${state.totalVolume.toStringAsFixed(1)} kg',
                    color: ColorConstants.primaryColor,
                  ),
                  SummaryCard(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Sets Completed',
                    value:
                        '${state.totalSetsCompleted} / ${state.totalSetsInPlan}',
                    color: ColorConstants.primaryColor,
                  ),
                  SummaryCard(
                    icon: Icons.repeat_rounded,
                    label: 'Reps Completed',
                    value: '${state.totalRepsCompleted} reps',
                    color: ColorConstants.primaryColor,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Save + Finish Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      SaveAndFinishWorkout(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shadowColor: ColorConstants.primaryColor.withValues(
                      alpha: 0.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: ColorConstants.buttonColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'FINISH & SAVE WORKOUT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
