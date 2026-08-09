import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_state.dart';

class RestView extends StatelessWidget {
  const RestView({super.key, required this.context, required this.state});

  final BuildContext context;
  final WorkoutSessionState state;

  @override
  Widget build(BuildContext context) {
    final restRemaining = state.restSecondsRemaining ?? 0;
    final nextEx = state.nextPlanExercise;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'rest_view_rest_time_title'.tr(),
            style: TextStyle(
              fontSize: 24,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          //  Circular Countdown Timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: CircularProgressIndicator(
                  value: (restRemaining / 60.0).clamp(0.0, 1.0),
                  strokeWidth: 12,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorConstants.primaryColor,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "rest_view_seconds_remaining".tr(
                      namedArgs: {"seconds": restRemaining.toString()},
                    ),
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'rest_view_remaining'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 36),

          // Quick Rest Adjustments
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      const AddRestTime(seconds: 30),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),

                  child: const Text(
                    '+30s',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      const SkipRestTimer(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor.withValues(
                      alpha: 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),

                  child: Text(
                    'rest_view_skip_rest_button'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Upcoming exercise
          if (nextEx != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(4, 8),
                  ),
                ],
                border: Border.all(
                  color: ColorConstants.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: ColorConstants.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorConstants.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: ColorConstants.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'rest_view_coming_up'.tr(),
                          style: TextStyle(
                            color: ColorConstants.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nextEx.exercise?.name ??
                              'rest_view_next_exercise_fallback'.tr(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: ColorConstants.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "rest_view_sets_reps_target".tr(
                            namedArgs: {
                              "sets": nextEx.targetSets.toString(),
                              "reps": nextEx.targetRepsOrSeconds.toString(),
                            },
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: ColorConstants.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
