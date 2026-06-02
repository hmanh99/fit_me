import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

class ExerciseEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const ExerciseEmptyState({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: ExerciseTheme.gradientStart.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ExerciseTheme.gradientStart.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    gradient: ExerciseTheme.gradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sports_gymnastics_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'No Exercises Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ColorConstants.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "We couldn't find any exercises right now. Pull down to refresh or tap the button below.",
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.secondaryTextColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 32),
              _GradientActionButton(
                label: 'Refresh',
                icon: Icons.refresh_rounded,
                onPressed: onRefresh!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GradientActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: ExerciseTheme.gradient,
        boxShadow: [
          BoxShadow(
            color: ExerciseTheme.gradientStart.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}
