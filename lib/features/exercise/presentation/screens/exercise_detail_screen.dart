import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_detail_content.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_error_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_gradient_app_bar.dart';
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
            return ExerciseDetailContent(exercise: state.exercise);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
