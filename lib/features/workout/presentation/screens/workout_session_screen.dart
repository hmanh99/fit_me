import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/core/helper/format_duration.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/screens/summary_screen.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/active_set_view.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/confirm_exit.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/paused_overlay.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/rest_view.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  int _lastExerciseIndex = -1;
  int _lastSetNumber = -1;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _syncControllers(WorkoutSessionState state) {
    if (state.currentExerciseIndex != _lastExerciseIndex ||
        state.currentSetNumber != _lastSetNumber) {
      _lastExerciseIndex = state.currentExerciseIndex;
      _lastSetNumber = state.currentSetNumber;

      final currentEx = state.currentPlanExercise;
      if (currentEx != null) {
        _repsController.text = currentEx.targetRepsOrSeconds.toString();
        if (_weightController.text.isEmpty) {
          _weightController.text = "0.0";
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutSessionBloc, WorkoutSessionState>(
      listener: (context, state) {
        if (state.status == WorkoutStatus.finished) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout saved successfully! Great job!'),
              backgroundColor: ColorConstants.snackBarSuccessColor,
            ),
          );
          context.goNamed(AppRouteNames.appWorkouts);
        }
      },
      builder: (context, state) {
        _syncControllers(state);

        if (state.status == WorkoutStatus.summary ||
            state.status == WorkoutStatus.finished) {
          return SummaryScreen(context: context, state: state);
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              showExitConfirmationDialog(context);
            }
          },
          child: Scaffold(
            backgroundColor: ColorConstants.backgroundColor,
            appBar: _buildAppBar(context, state),
            body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: state.status == WorkoutStatus.resting
                              ? RestView(context: context, state: state)
                              : ActiveSetView(
                                  context: context,
                                  state: state,
                                  repsController: _repsController,
                                  weightController: _weightController,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.status == WorkoutStatus.paused)
                  PausedOverlay(context: context, state: state),
              ],
            ),
          ),
        );
      },
    );
  }

  // App Bar
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WorkoutSessionState state,
  ) {
    return AppBar(
      backgroundColor: ColorConstants.appBarBackgroundColor,
      toolbarHeight: 64,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: ColorConstants.white, size: 30),
        onPressed: () => showExitConfirmationDialog(context),
      ),
      title: Text(
        state.plan.planName.isNotEmpty
            ? state.plan.planName
            : 'Workout Session',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        // Timer chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 8, bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                formatDuration(state.elapsedSeconds),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Pause/Resume button
        IconButton(
          padding: EdgeInsets.only(right: 8, bottom: 4),
          icon: Icon(
            state.status == WorkoutStatus.paused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            if (state.status == WorkoutStatus.paused) {
              context.read<WorkoutSessionBloc>().add(const ResumeWorkout());
            } else {
              context.read<WorkoutSessionBloc>().add(const PauseWorkout());
            }
          },
        ),
      ],
    );
  }
}
