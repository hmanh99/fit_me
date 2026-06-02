import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_difficulty_badge.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

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
          margin: const EdgeInsets.symmetric(
            horizontal: ExerciseTheme.horizontalPadding,
            vertical: 8,
          ),
          decoration: ExerciseTheme.cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ExerciseAvatar(name: exercise.name),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ExerciseDifficultyBadge(
                            difficulty: exercise.difficulty,
                            compact: true,
                          ),
                          if (exercise.muscleGroups.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _MusclePreviewChip(
                              label: exercise.muscleGroups.first,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _ExerciseMetaRow(exercise: exercise),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
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

class _ExerciseAvatar extends StatelessWidget {
  final String name;

  const _ExerciseAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'E';

    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        gradient: ExerciseTheme.gradient,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _MusclePreviewChip extends StatelessWidget {
  final String label;

  const _MusclePreviewChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ExerciseMetaRow extends StatelessWidget {
  final ExerciseEntity exercise;

  const _ExerciseMetaRow({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (exercise.calories != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 14,
                color: Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                '${exercise.calories} kcal',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              exercise.requiresEquipment
                  ? Icons.fitness_center_rounded
                  : Icons.bolt_rounded,
              size: 14,
              color: ColorConstants.labelColor,
            ),
            const SizedBox(width: 4),
            Text(
              exercise.requiresEquipment
                  ? '${exercise.equipments!.length} equipments'
                  : 'Bodyweight',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
