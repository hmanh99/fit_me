import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/core/helper/format_duration.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_event.dart';

import '../bloc/workout_session_state.dart';

class PausedOverlay extends StatelessWidget {
  const PausedOverlay({super.key, required this.context, required this.state});

  final BuildContext context;
  final WorkoutSessionState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.black.withValues(alpha: 0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_rounded,
                  size: 40,
                  color: ColorConstants.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'workout_paused_overlay_title'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "paused_overlay_elapsed_time".tr(
                  namedArgs: {"duration": formatDuration(state.elapsedSeconds)},
                ),
                style: TextStyle(
                  color: ColorConstants.greyShade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      const ResumeWorkout(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'paused_overlay_resume_button'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      const FinishWorkoutEarly(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorConstants.greyShade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "paused_overlay_finish_early_button".tr(),
                    style: TextStyle(color: ColorConstants.greyShade800),
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
