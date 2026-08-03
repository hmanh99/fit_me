import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_app_bar.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_card.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_empty_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_error_state.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_loading_skeleton.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseBloc>().add(const ExerciseFetchStarted());
  }

  void _fetchExercises() {
    context.read<ExerciseBloc>().add(const ExerciseFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExerciseAppBar(
        onBack: () {
          context.pop();
        },
        title: 'Exercises Library',
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const ExerciseLoadingSkeleton();
          } else if (state is ExerciseError) {
            return ExerciseErrorState(
              errorMessage: state.message,
              onRetry: _fetchExercises,
            );
          } else if (state is ExerciseEmpty) {
            return ExerciseEmptyState(onRefresh: _fetchExercises);
          } else if (state is ExerciseSuccess) {
            return _ExerciseListView(
              exercises: state.exercises,
              onRefresh: _fetchExercises,
            );
          }
          return const ExerciseLoadingSkeleton(isDetailPage: false);
        },
      ),
    );
  }
}

class _ExerciseListView extends StatelessWidget {
  final List<ExerciseEntity> exercises;
  final VoidCallback onRefresh;

  const _ExerciseListView({required this.exercises, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: ExerciseTheme.gradientStart,
      backgroundColor: Colors.white,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          MediaQuery.of(context).padding.bottom,
        ),
        itemCount: exercises.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return TweenAnimationBuilder<double>(
            key: ValueKey(exercise.exerciseId),
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 350 + (index * 60)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 24 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: ExerciseListCard(
              exercise: exercise,
              onTap: () {
                context.pushNamed(
                  AppRouteNames.appExerciseDetail,
                  pathParameters: {
                    'exerciseId': exercise.exerciseId.toString(),
                  },
                  queryParameters: {'planName': exercise.name},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
