import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExerciseError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ExerciseEmpty) {
            return const Center(child: Text('No exercises found.'));
          } else if (state is ExerciseSuccess) {
            final exercises = state.exercises;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExerciseBloc>().add(const ExerciseFetchStarted());
              },
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(''),
                    trailing: Text(exercise.difficulty.name),
                    onTap: () {
                      // Navigate to details
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
