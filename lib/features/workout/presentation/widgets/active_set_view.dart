import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/plan_exercise_entity.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/session_stepper_input.dart';

class ActiveSetView extends StatelessWidget {
  const ActiveSetView({
    super.key,
    required this.context,
    required this.state,
    required this.weightController,
    required this.repsController,
  });

  final BuildContext context;
  final WorkoutSessionState state;
  final TextEditingController weightController;
  final TextEditingController repsController;

  @override
  Widget build(BuildContext context) {
    final currentEx = state.currentPlanExercise;
    if (currentEx == null) {
      return const Center(child: Text("No exercise found in plan"));
    }

    final exerciseName =
        currentEx.exercise?.name ??
        'Exercise ${state.currentExerciseIndex + 1}';
    final targetRepsSecs = currentEx.targetRepsOrSeconds;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Title Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (currentEx.exercise?.muscleGroups != null)
                      ...currentEx.exercise!.muscleGroups.map(
                        (muscleGroups) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorConstants.greyShade300,
                            ),
                          ),
                          child: Text(
                            muscleGroups,
                            style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Set Inputs (Weight + Reps)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Set',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Weight Input Row
                StepperInput(
                  label: 'Weight (kg)',
                  controller: weightController,
                  icon: Icons.fitness_center_rounded,
                  step: 2.5,
                  isDecimal: true,
                ),

                const SizedBox(height: 8),

                // Reps Input Row
                StepperInput(
                  label: 'Reps/Secs',
                  controller: repsController,
                  icon: Icons.repeat_rounded,
                  step: 1.0,
                  isDecimal: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          //  Sets Checklist for Current Exercise
          _buildSetsChecklist(state, currentEx),

          const SizedBox(height: 12),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                final reps =
                    int.tryParse(repsController.text) ?? targetRepsSecs;
                final weight = double.tryParse(weightController.text) ?? 0.0;
                context.read<WorkoutSessionBloc>().add(
                  CompleteCurrentSet(repsCompleted: reps, weightUsed: weight),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shadowColor: ColorConstants.primaryColor.withValues(alpha: 0.4),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: ColorConstants.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isLastSetOfCurrentExercise && state.isLastExercise
                            ? 'COMPLETE WORKOUT'
                            : 'COMPLETE SET',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.buttonTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      const SkipCurrentExercise(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: ColorConstants.greyShade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Skip Exercise',
                    style: TextStyle(
                      color: ColorConstants.greyShade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      const FinishWorkoutEarly(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: ColorConstants.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Finish Early',
                    style: TextStyle(
                      color: ColorConstants.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetsChecklist(
    WorkoutSessionState state,
    PlanExerciseEntity currentEx,
  ) {
    final loggedSets = state.completedSets
        .where((s) => s.exerciseId == currentEx.exerciseId)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorConstants.greyShade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sets Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryColor,
                ),
              ),
              Text(
                '${loggedSets.length} / ${currentEx.targetSets} completed',
                style: TextStyle(
                  fontSize: 12,
                  color: ColorConstants.greyShade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentEx.targetSets,
            itemBuilder: (context, index) {
              final setNum = index + 1;
              final completed = loggedSets.firstWhere(
                (s) => s.setNumber == setNum,
                orElse: () => const CompletedSetData(
                  exerciseId: -1,
                  exerciseName: '',
                  setNumber: -1,
                  repsCompleted: 0,
                ),
              );

              final isCompleted = completed.setNumber != -1;
              final isCurrent = setNum == state.currentSetNumber;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? ColorConstants.primaryColor.withValues(alpha: 0.2)
                      : isCurrent
                      ? ColorConstants.primaryColor.withValues(alpha: 0.2)
                      : ColorConstants.greyShade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted
                        ? ColorConstants.primaryColor
                        : isCurrent
                        ? ColorConstants.primaryColor
                        : ColorConstants.greyShade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : isCurrent
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isCompleted
                          ? ColorConstants.blue
                          : isCurrent
                          ? ColorConstants.blue
                          : ColorConstants.greyShade400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Set $setNum',
                      style: TextStyle(
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isCurrent
                            ? ColorConstants.primaryColor
                            : ColorConstants.greyShade700,
                      ),
                    ),
                    const Spacer(),
                    if (isCompleted)
                      Text(
                        completed.isSkipped
                            ? 'Skipped'
                            : '${completed.repsCompleted} reps ${completed.weightUsed != null && completed.weightUsed! > 0 ? "${completed.weightUsed} kg" : ""}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: completed.isSkipped
                              ? ColorConstants.red
                              : ColorConstants.blue,
                        ),
                      )
                    else if (isCurrent)
                      const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.blue,
                        ),
                      )
                    else
                      Text(
                        'Target: ${currentEx.targetRepsOrSeconds} reps',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.greyShade900,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
