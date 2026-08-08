import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/plan_exercise_entity.dart';

class WorkoutExerciseCard extends StatefulWidget {
  final PlanExerciseEntity planExercise;
  final VoidCallback? onTap;

  const WorkoutExerciseCard({
    super.key,
    required this.planExercise,
    this.onTap,
  });

  @override
  State<WorkoutExerciseCard> createState() => _WorkoutExerciseCardState();
}

class _WorkoutExerciseCardState extends State<WorkoutExerciseCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.planExercise.exercise;
    final exerciseName = exercise?.name ?? "Exercise";
    final targetSets = widget.planExercise.targetSets;
    final targetRepsOrSeconds = widget.planExercise.targetRepsOrSeconds;
    final order = widget.planExercise.orderInWorkout;

    // Difficulty colors
    Color diffBgColor = ColorConstants.difficultyBeginnerBgColor;
    Color diffTextColor = ColorConstants.difficultyBeginnerTextColor;
    String diffLabel = "Beginner";

    if (exercise != null) {
      switch (exercise.difficulty) {
        case DifficultyLevel.beginner:
          diffBgColor = ColorConstants.difficultyBeginnerBgColor;
          diffTextColor = ColorConstants.difficultyBeginnerTextColor;
          diffLabel = "Beginner";
          break;
        case DifficultyLevel.intermediate:
          diffBgColor = ColorConstants.difficultyIntermediateBgColor;
          diffTextColor = ColorConstants.difficultyIntermediateTextColor;
          diffLabel = "Intermediate";
          break;
        case DifficultyLevel.advanced:
          diffBgColor = ColorConstants.difficultyAdvancedBgColor;
          diffTextColor = ColorConstants.difficultyAdvancedTextColor;
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
            color: ColorConstants.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: ColorConstants.borderLightColor,
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
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    order.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: ColorConstants.white,
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
                                color: ColorConstants.primaryColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                exercise.muscleGroups.first,
                                style: const TextStyle(
                                  color: ColorConstants.primaryColor,
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
                          color: ColorConstants.textPrimaryColor,
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
                              color: ColorConstants.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.repeat_rounded,
                                  size: 13,
                                  color:ColorConstants.buttonColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "$targetSets x $targetRepsOrSeconds",
                                  style: const TextStyle(
                                    color: ColorConstants.primaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Calories badge
                          if (exercise?.calories != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: ColorConstants.caloriesIconColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 13,
                                    color: ColorConstants.caloriesIconColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${exercise!.calories} kcal",
                                    style: const TextStyle(
                                      color: ColorConstants.caloriesTextColor,
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
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: ColorConstants.greyShade400,
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
