import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/plan_exercise_entity.dart';

class ExerciseCard extends StatefulWidget {
  final PlanExerciseEntity planExercise;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.planExercise,
    this.onTap,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.planExercise.exercise;
    final exerciseName = exercise?.name ?? "Exercise";
    final targetSets = widget.planExercise.targetSets;
    final targetRepsOrSeconds = widget.planExercise.targetRepsOrSeconds;
    final order = widget.planExercise.orderInWorkout;

    // Difficulty colors
    Color diffBgColor = Colors.green.shade50;
    Color diffTextColor = Colors.green.shade700;
    String diffLabel = "Beginner";

    if (exercise != null) {
      switch (exercise.difficulty) {
        case DifficultyLevel.beginner:
          diffBgColor = const Color(0xFFE8F5E9);
          diffTextColor = const Color(0xFF2E7D32);
          diffLabel = "Beginner";
          break;
        case DifficultyLevel.intermediate:
          diffBgColor = const Color(0xFFFFF3E0);
          diffTextColor = const Color(0xFFEF6C00);
          diffLabel = "Intermediate";
          break;
        case DifficultyLevel.advanced:
          diffBgColor = const Color(0xFFFFEBEE);
          diffTextColor = const Color(0xFFC62828);
          diffLabel = "Advanced";
          break;
      }
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade100,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Order Index Circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    order.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Difficulty and Muscle Group tags
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: diffBgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              diffLabel,
                              style: TextStyle(
                                color: diffTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (exercise != null &&
                              exercise.muscleGroups.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                exercise.muscleGroups.first,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Exercise name
                      Text(
                        exerciseName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Targets badges row
                      Row(
                        children: [
                          // Target sets & reps/seconds badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF92A3FD).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.repeat_rounded,
                                  size: 13,
                                  color: Color(0xFF92A3FD),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "$targetSets x $targetRepsOrSeconds",
                                  style: const TextStyle(
                                    color: Color(0xFF7F77DD),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Calories badge (if available)
                          if (exercise?.calories != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 13,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${exercise!.calories} kcal",
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Chevron icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
