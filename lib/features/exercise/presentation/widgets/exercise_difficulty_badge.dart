import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';

class ExerciseDifficultyStyle {
  final Color backgroundColor;
  final Color textColor;
  final String label;

  const ExerciseDifficultyStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.label,
  });

  static ExerciseDifficultyStyle fromLevel(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.beginner:
        return ExerciseDifficultyStyle(
          backgroundColor: Color(0xFFE8F5E9),
          textColor: Color(0xFF2E7D32),
          label: 'beginner'.tr(),
        );
      case DifficultyLevel.intermediate:
        return ExerciseDifficultyStyle(
          backgroundColor: Color(0xFFFFF3E0),
          textColor: Color(0xFFFF8B2B),
          label: 'intermediate'.tr(),
        );
      case DifficultyLevel.advanced:
        return ExerciseDifficultyStyle(
          backgroundColor: const Color(0xFFFFEBEE),
          textColor: const Color(0xFFC62828),
          label: 'advanced'.tr(),
        );
    }
  }
}

class ExerciseDifficultyBadge extends StatelessWidget {
  final DifficultyLevel difficulty;
  final bool compact;

  const ExerciseDifficultyBadge({
    super.key,
    required this.difficulty,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = ExerciseDifficultyStyle.fromLevel(difficulty);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.textColor,
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
