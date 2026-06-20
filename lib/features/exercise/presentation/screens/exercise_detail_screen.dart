import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_detail_header.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_error_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_gradient_app_bar.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_info_section.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_instruction_list.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_loading_skeleton.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int exerciseId;
  final String exerciseName;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseBloc>().add(
      ExerciseFetchByIdStarted(exerciseId: widget.exerciseId),
    );
  }

  void _fetchExercise() {
    context.read<ExerciseBloc>().add(
      ExerciseFetchByIdStarted(exerciseId: widget.exerciseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: ExerciseGradientAppBar(
        title: widget.exerciseName,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const ExerciseLoadingSkeleton(isDetailPage: true);
          } else if (state is ExerciseError) {
            return ExerciseErrorState(
              errorMessage: state.message,
              onRetry: _fetchExercise,
            );
          } else if (state is ExerciseDetailSuccess) {
            final exercise = state.exercise;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExerciseBloc>().add(
                  ExerciseFetchByIdStarted(exerciseId: exercise.exerciseId),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ExerciseDetailHeader(exercise: exercise),
                      const SizedBox(height: 16),
                      ExerciseInfoSection(
                        title: 'Target Muscles',
                        icon: Icons.accessibility_new_rounded,
                        items: exercise.muscleGroups,
                        chipAccentColor: const Color(0xFF7F77DD),
                      ),
                      if (exercise.requiresEquipment) ...[
                        const SizedBox(height: 16),
                        ExerciseInfoSection(
                          title: 'Equipment',
                          icon: Icons.fitness_center_rounded,
                          items: exercise.equipments ?? [],
                        ),
                      ],
                      if (exercise.instructions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ExerciseInstructionList(
                          instructions: exercise.instructions,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
