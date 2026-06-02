import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_tag_chip.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

class ExerciseInfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Color? chipAccentColor;

  const ExerciseInfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    this.chipAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: ExerciseTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ExerciseTheme.gradientStart),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => ExerciseTagChip(
                    label: item,
                    accentColor: chipAccentColor,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
