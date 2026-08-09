import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_difficulty_badge.dart';

class ExerciseDetailHeader extends StatelessWidget {
  final ExerciseEntity exercise;

  const ExerciseDetailHeader({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.socialBorderColor),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textPrimaryColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ExerciseDifficultyBadge(difficulty: exercise.difficulty),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (exercise.calories != null)
                _MetaChip(
                  icon: Icons.local_fire_department_rounded,
                  label: '${exercise.calories} kcal',
                  color: ColorConstants.caloriesIconColor,
                ),
              _MetaChip(
                icon: exercise.requiresEquipment
                    ? Icons.fitness_center_rounded
                    : Icons.bolt_rounded,
                label: exercise.requiresEquipment
                    ? 'equipment_count'.plural(exercise.equipments!.length)
                    : 'bodyweight'.tr(),
                color: ColorConstants.iconColor,
              ),
              if (exercise.muscleGroups.isNotEmpty)
                _MetaChip(
                  icon: Icons.accessibility_new_rounded,
                  label:
                      'muscle_group_count'.plural(exercise.muscleGroups.length),
                  color: ColorConstants.iconColor,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
