import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            onPressed: () {
              context.pop();
            },
          ),
        ),
        title: Row(
          children: [
            Text(
              widget.exerciseName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ],
        ),
        toolbarHeight: 60,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExerciseError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ExerciseDetailSuccess) {
            final exercise = state.exercise;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Muscles: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
                          children: exercise.muscleGroups
                              .map((m) => Chip(label: Text(m)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Difficulty: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Chip(label: Text(exercise.difficulty.name)),
                    ],
                  ),

                  if (exercise.requiresEquipment) ...[
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            "Equipments: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            spacing: 12.0,
                            runSpacing: 4.0,
                            children: (exercise.equipments ?? [])
                                .map((e) => Chip(label: Text(e)))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (exercise.instructions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exercise.instructions.length,
                      itemBuilder: (context, index) {
                        final instruction = exercise.instructions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('- $instruction'),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
