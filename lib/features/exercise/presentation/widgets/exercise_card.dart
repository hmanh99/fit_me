import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';

class ExerciseListCard extends StatefulWidget {
  final ExerciseEntity exercise;
  final VoidCallback onTap;

  const ExerciseListCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  State<ExerciseListCard> createState() => _ExerciseListCardState();
}

class _ExerciseListCardState extends State<ExerciseListCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [Expanded(child: _ExerciseAvatar(exercise: exercise))],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseAvatar extends StatelessWidget {
  final ExerciseEntity exercise;

  const _ExerciseAvatar({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Hero(
        tag: "exercise-image-${exercise.exerciseId}",
        child: exercise.url == null
            ? Icon(Icons.fitness_center_outlined, size: 20)
            : Image.network(exercise.url!),
      ),
    );
  }
}
