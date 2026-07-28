import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/plan_exercise_entity.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_session_state.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/session_stepper_input.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/widgets/session_summary_card.dart';

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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutSessionBloc, WorkoutSessionState>(
      listener: (context, state) {
        if (state.status == WorkoutStatus.finished) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout saved successfully! Great job!'),
              backgroundColor: Colors.green,
            ),
          );
          context.goNamed(AppRouteNames.appWorkouts);
        }
      },
      builder: (context, state) {
        _syncControllers(state);

        if (state.status == WorkoutStatus.summary ||
            state.status == WorkoutStatus.finished) {
          return _buildSummaryScreen(context, state);
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showExitConfirmationDialog(context);
            }
          },
          child: Scaffold(
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
                              ? _buildRestTimerView(context, state)
                              : _buildActiveSetView(context, state),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.status == WorkoutStatus.paused)
                  _buildPausedOverlay(context, state),
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
      toolbarHeight: 64,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: Colors.white, size: 30),
        onPressed: () => _showExitConfirmationDialog(context),
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
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                _formatDuration(state.elapsedSeconds),
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

  Widget _buildActiveSetView(BuildContext context, WorkoutSessionState state) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                    color: Colors.black87,
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
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            muscleGroups,
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF92A3FD),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Weight Input Row
                StepperInput(
                  label: 'Weight (kg)',
                  controller: _weightController,
                  icon: Icons.fitness_center_rounded,
                  step: 2.5,
                  isDecimal: true,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                // Reps Input Row
                StepperInput(
                  label: 'Reps/Secs',
                  controller: _repsController,
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
                    int.tryParse(_repsController.text) ?? targetRepsSecs;
                final weight = double.tryParse(_weightController.text) ?? 0.0;
                context.read<WorkoutSessionBloc>().add(
                  CompleteCurrentSet(repsCompleted: reps, weightUsed: weight),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shadowColor: const Color(0xFF92A3FD).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
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
                          color: Colors.white,
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Skip Exercise',
                    style: TextStyle(
                      color: Colors.grey.shade700,
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.orange.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Finish Early',
                    style: TextStyle(
                      color: Colors.orange.shade800,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
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
                  color: Colors.black87,
                ),
              ),
              Text(
                '${loggedSets.length} / ${currentEx.targetSets} completed',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                      ? Color(0xFF92A3FD).withValues(alpha: 0.2)
                      : isCurrent
                      ? Color(0xFF92A3FD).withValues(alpha: 0.2)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted
                        ? Color(0xFF92A3FD)
                        : isCurrent
                        ? Color(0xFF92A3FD)
                        : Colors.grey.shade200,
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
                          ? Colors.blue
                          : isCurrent
                          ? Colors.blue
                          : Colors.grey.shade400,
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
                            ? Colors.black87
                            : Colors.grey.shade700,
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
                          color: completed.isSkipped ? Colors.red : Colors.blue,
                        ),
                      )
                    else if (isCurrent)
                      const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )
                    else
                      Text(
                        'Target: ${currentEx.targetRepsOrSeconds} reps',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade900,
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

  Widget _buildRestTimerView(BuildContext context, WorkoutSessionState state) {
    final restRemaining = state.restSecondsRemaining ?? 0;
    final nextEx = state.nextPlanExercise;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'REST TIME',
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
                    Color(0xFF92A3FD),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${restRemaining}s',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('remaining', style: TextStyle(fontSize: 16)),
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
                    backgroundColor: const Color(
                      0xFF92A3FD,
                    ).withValues(alpha: 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),

                  child: const Text(
                    'SKIP REST',
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
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
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COMING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nextEx.exercise?.name ?? 'Next Exercise',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${nextEx.targetSets} sets × ${nextEx.targetRepsOrSeconds} reps',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
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

  //pause dialog
  Widget _buildPausedOverlay(BuildContext context, WorkoutSessionState state) {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF92A3FD).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_rounded,
                  size: 40,
                  color: Color(0xFF92A3FD),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Workout Paused',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Elapsed time: ${_formatDuration(state.elapsedSeconds)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
                    backgroundColor: const Color(0xFF92A3FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'RESUME WORKOUT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Finish Early',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Workout summary screen
  Widget _buildSummaryScreen(BuildContext context, WorkoutSessionState state) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: Colors.white, size: 30),
          onPressed: () => _showExitConfirmationDialog(context),
        ),
        toolbarHeight: 64,
        title: const Text(
          'Workout Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            ),
          ),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You completed ${state.plan.planName}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
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
                    value: _formatDuration(state.elapsedSeconds),
                    color: const Color(0xFF92A3FD),
                  ),
                  SummaryCard(
                    icon: Icons.fitness_center_rounded,
                    label: 'Total Volume',
                    value: '${state.totalVolume.toStringAsFixed(1)} kg',
                    color: const Color(0xFF7F77DD),
                  ),
                  SummaryCard(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Sets Completed',
                    value:
                        '${state.totalSetsCompleted} / ${state.totalSetsInPlan}',
                    color: const Color(0xFFC58BF2),
                  ),
                  SummaryCard(
                    icon: Icons.repeat_rounded,
                    label: 'Reps Completed',
                    value: '${state.totalRepsCompleted} reps',
                    color: const Color(0xFFEEA282),
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
                    shadowColor: const Color(0xFF92A3FD).withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'FINISH & SAVE WORKOUT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Quit Workout?'),
          content: const Text(
            'Are you sure you want to exit? Your progress for this session will not be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Continue Workout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.goNamed(AppRouteNames.appWorkouts);
              },
              child: const Text('Quit', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
