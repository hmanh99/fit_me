import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/session_stepper_input.dart';

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
      return Center(child: Text("no_exercise_found".tr()));
    }

    final exerciseName =
        currentEx.exerciseName ;
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
                Text(
                  'active_set_view_current_set_title'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Weight Input Row
                StepperInput(
                  label: 'weight'.tr(),
                  controller: weightController,
                  icon: Icons.fitness_center_rounded,
                  step: 2.5,
                  isDecimal: true,
                ),

                const SizedBox(height: 8),

                // Reps Input Row
                StepperInput(
                  label: 'active_set_view_reps_input'.tr(),
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
                            ? 'active_set_view_complete_workout_button'.tr()
                            : 'active_set_view_complete_set_button'.tr(),
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
                    'active_set_view_skip_exercise_button'.tr(),
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
                    'active_set_view_finish_early_button'.tr(),
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
              Text(
                'active_set_view_sets_progress_title'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryColor,
                ),
              ),
              Text(
                "active_set_view_sets_progress_count".tr(
                  namedArgs: {
                    "completed": loggedSets.length.toString(),
                    "target": currentEx.targetSets.toString(),
                  },
                ),
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
                      'active_set_view_set'.tr(
                        namedArgs: {"number": setNum.toString()},
                      ),
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
                            ? 'skipped'
                            : 'active_set_view_reps_completed_with_weight'.tr(
                                namedArgs: {
                                  "reps": completed.repsCompleted.toString(),
                                  "weight":
                                      completed.weightUsed != null &&
                                          completed.weightUsed! > 0
                                      ? completed.weightUsed!.toStringAsFixed(1)
                                      : "0",
                                },
                              ),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: completed.isSkipped
                              ? ColorConstants.red
                              : ColorConstants.blue,
                        ),
                      )
                    else if (isCurrent)
                      Text(
                        'active'.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.blue,
                        ),
                      )
                    else
                      Text(
                        'active_set_view_target_reps'.tr(
                          namedArgs: {
                            "target": currentEx.targetRepsOrSeconds.toString(),
                          },
                        ),
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
